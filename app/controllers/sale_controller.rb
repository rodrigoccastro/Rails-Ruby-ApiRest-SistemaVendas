class SaleController < ApplicationController
    def index
        sales = Sale.order('created_at DESC');
        render json: {status: 'SUCCESS', message:'Loaded sales', data:sales},status: :ok
    end

    def show
        sale = Sale.find(params[:id])
        render json: {status: 'SUCCESS', message:'Loaded sale', data:[ "sale": sale, "productsales": sale.productsales]},status: :ok
    end
    
    def create
        sale = nil
        ret = false
        newArrPrd = []
        begin
            Sale.transaction do
                sale = Sale.new(sale_params)
                if sale.save
                    sale_id = sale[:id]
                    addProductSales(sale_id)
                    ret = true
                end 
            end
        rescue StandardError, AnotherError => e
            ret = false
            #puts e.inspect
            raise ActiveRecord::Rollback, e.inspect
        ensure

        end

        if ret==true
            render json: {status: 'SUCCESS', message:'Saved sale', data:[ "sale": sale, "productsales": sale.productsales]},status: :ok
        else
            render json: {status: 'ERROR', message:'Sale not saved', data:sale.errors},status: :unprocessable_entity
        end
          
    end

    def addProductSales(sale_id)
        arrProducts = params[:productsales]
        arrProducts.each do |product|
            newproduct = Hash.new
            newproduct[:sale_id] = "#{sale_id}"
            newproduct[:product_id] = product[:product_id]
            newproduct[:value] = product[:value]
            newproduct[:quantity] = product[:quantity]
            retprd = Productsale.new(newproduct)
            retprd.save
        end
    end

    def delProductSales(sale_id)
        Productsale.where(:sale_id => sale_id).delete_all
    end

    def update
        ret = false
        sale = nil
        begin
            Sale.transaction do
                sale_id = params[:id]
                sale = Sale.find(sale_id)
                newsale = Hash.new
                newsale[:id] = sale_id
                newsale[:client_id] = params[:client_id]
                newsale[:seller_id] = params[:seller_id]
                newsale[:created_at] = sale[:created_at]
                newsale[:updated_at] = sale[:updated_at]
                if sale.update(newsale)
                    delProductSales(sale_id)
                    addProductSales(sale_id)
                    ret = true
                end 
            end
        rescue StandardError, AnotherError => e
            ret = false
            #puts e.inspect
            raise ActiveRecord::Rollback, e.inspect
        ensure

        end

        if ret==true
            render json: {status: 'SUCCESS', message:'Updated sale', data:[ "sale": sale, "productsales": sale.productsales]},status: :ok
        else
            render json: {status: 'ERROR', message:'Sale not updated', data:sale.errors},status: :unprocessable_entity
        end
    end

    def destroy
        sale_id = params[:id]
        delProductSales(sale_id)
        sale = Sale.find(params[:id])
        if sale.destroy
            render json: {status: 'SUCCESS', message:'Deleted sale', data:sale},status: :ok
        else
            render json: {status: 'ERROR', message:'sale not deleted', data:sale.errors},status: :unprocessable_entity
        end
    end

    private

    def sale_params
        params.permit(:client_id, :seller_id, :productsales)
    end

    def sale_params_update
        params.permit(:id, :client_id, :seller_id, :productsales)
    end
end 