module Api
  class ProductsController < ApplicationController
    include Authentication

    before_action :require_admin!, only: [:create, :update, :destroy]
    before_action :set_product, only: [:show, :update, :destroy]

    # GET /api/products
    # Admin and staff can view all products.
    def index
      products = Product.order(:name)
      render json: products, status: :ok
    end

    # GET /api/products/:id
    def show
      render json: @product, status: :ok
    end

    # POST /api/products
    # Admin only.
    def create
      product = Product.new(product_params)

      if product.save
        render json: product, status: :created
      else
        render json: { errors: product.errors.full_messages },
               status: :unprocessable_entity
      end
    end

    # PATCH /api/products/:id
    # Admin only.
    def update
      if @product.update(product_params)
        render json: @product, status: :ok
      else
        render json: { errors: @product.errors.full_messages },
               status: :unprocessable_entity
      end
    end

    # DELETE /api/products/:id
    # Admin only.
    def destroy
      if @product.destroy
        head :no_content
      else
        render json: { errors: @product.errors.full_messages },
               status: :unprocessable_entity
      end
    end

    private

    def set_product
      @product = Product.find_by(id: params[:id])

      return if @product

      render json: { error: "Product not found" },
             status: :not_found
    end

    def product_params
      params.require(:product).permit(
        :name,
        :sku,
        :description,
        :price,
        :stock_quantity
      )
    end
  end
end
