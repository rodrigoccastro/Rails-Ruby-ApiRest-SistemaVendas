class SaleController < ApplicationController
    def index
        sales = Sale.order('created_at DESC');
        render json: {status: 'SUCCESS', message:'Loaded sales', data:sales},status: :ok
    end

    def show
        sale = Sale.find(params[:id])
        render json: {status: 'SUCCESS', message:'Loaded sale', data:sale},status: :ok
    end
    
    def create
        sale = nil
        ret = false
        newArrPrd = []
        begin
            Sale.transaction do
                sale = Sale.new(sale_params)
                if sale.save
                    count = 0
                    arrProducts = params[:products]
                    sale_id = sale[:id]
                    arrProducts.each do |product|
                        newproduct = Hash.new
                        newproduct[:sale_id] = "#{sale_id}"
                        newproduct[:product_id] = product[:product_id]
                        newproduct[:value] = product[:value]
                        newproduct[:quantity] = product[:quantity]
                        retprd = Productsale.new(newproduct)
                        retprd.save
                        newArrPrd[count] = retprd
                        count = count + 1
                    end 
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
            render json: {status: 'SUCCESS', message:'Saved sale', data:sale},status: :ok
        else
            render json: {status: 'ERROR', message:'Sale not saved', data:sale.errors},status: :unprocessable_entity
        end
          
  end

  def destroy
      sale = Sale.find(params[:id])
      if sale.destroy
          render json: {status: 'SUCCESS', message:'Deleted sale', data:sale},status: :ok
      else
          render json: {status: 'ERROR', message:'sale not deleted', data:sale.errors},status: :unprocessable_entity
      end
  end

  def update
      sale = Sale.find(params[:id])
      if sale.update(sale_params)
          render json: {status: 'SUCCESS', message:'Updated sale', data:sale},status: :ok
      else
          render json: {status: 'ERROR', message:'Sale not updated', data:sale.errors},status: :unprocessable_entity
      end
  end

    private

    def sale_params
        params.permit(:client_id, :seller_id, :products)
    end
end 