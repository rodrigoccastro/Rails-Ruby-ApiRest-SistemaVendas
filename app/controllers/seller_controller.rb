class SellerController < ApplicationController
    def index
        sellers = Seller.order('created_at DESC');
        render json: {status: 'SUCCESS', message:'Loaded sellers', data:sellers},status: :ok
    end

    def show
        seller = Seller.find(params[:id])
        render json: {status: 'SUCCESS', message:'Loaded seller', data:seller},status: :ok
    end

    def create
        seller = Seller.new(seller_params)

        if seller.save
            render json: {status: 'SUCCESS', message:'Saved seller', data:seller},status: :ok
        else
            render json: {status: 'ERROR', message:'Seller not saved', data:seller.errors},status: :unprocessable_entity
        end
    end

    def destroy
        seller = Seller.find(params[:id])
        if seller.destroy
            render json: {status: 'SUCCESS', message:'Deleted seller', data:seller},status: :ok
        else
            render json: {status: 'ERROR', message:'Seller not deleted', data:seller.errors},status: :unprocessable_entity
        end
    end

    def update
        seller = Seller.find(params[:id])
        if seller.update(seller_params)
            render json: {status: 'SUCCESS', message:'Updated seller', data:seller},status: :ok
        else
            render json: {status: 'ERROR', message:'Seller not updated', data:seller.errors},status: :unprocessable_entity
        end
    end

    private

    def seller_params
        params.permit(:number, :name, :email, :phone, :address)
    end
    end