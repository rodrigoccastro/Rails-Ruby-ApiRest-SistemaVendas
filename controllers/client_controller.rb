class ClientController < ApplicationController
    def index
      clients = Client.order('created_at DESC');
      render json: {status: 'SUCCESS', message:'Loaded clients', data:clients},status: :ok
  end

  def show
      client = Client.find(params[:id])
      render json: {status: 'SUCCESS', message:'Loaded client', data:client},status: :ok
  end

  def create
      client = Client.new(client_params)

      if client.save
          render json: {status: 'SUCCESS', message:'Saved client', data:client},status: :ok
      else
          render json: {status: 'ERROR', message:'Client not saved', data:client.errors},status: :unprocessable_entity
      end
  end

  def destroy
      client = Client.find(params[:id])
      if client.destroy
          render json: {status: 'SUCCESS', message:'Deleted client', data:client},status: :ok
      else
          render json: {status: 'ERROR', message:'client not deleted', data:client.errors},status: :unprocessable_entity
      end
  end


  def update
      client = Client.find(params[:id])
          if client.update(client_params)
          render json: {status: 'SUCCESS', message:'Updated client', data:client},status: :ok
      else
          render json: {status: 'ERROR', message:'Client not updated', data:client.errors},status: :unprocessable_entity
      end
  end

  private

  def client_params
      params.permit(:number, :name, :email, :phone, :address)
  end
end 