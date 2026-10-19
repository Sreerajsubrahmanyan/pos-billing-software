module Api
  class SuppliersController < ApplicationController
    include Authentication
    before_action :require_admin!
    before_action :set_supplier, only: [:show, :update, :destroy]

    def index
      render json: Supplier.order(:name)
    end

    def show
      render json: @supplier
    end

    def create
      supplier = Supplier.new(supplier_params)
      if supplier.save
        render json: supplier, status: :created
      else
        render json: { errors: supplier.errors.full_messages }, status: :unprocessable_entity
      end
    end

    def update
      if @supplier.update(supplier_params)
        render json: @supplier
      else
        render json: { errors: @supplier.errors.full_messages }, status: :unprocessable_entity
      end
    end

    def destroy
      @supplier.destroy!
      head :no_content
    end

    private

    def set_supplier
      @supplier = Supplier.find_by(id: params[:id])
      render json: { error: "Supplier not found" }, status: :not_found unless @supplier
    end

    def supplier_params
      params.require(:supplier).permit(:name, :contact_name, :phone, :email, :address, :status)
    end
  end
end
