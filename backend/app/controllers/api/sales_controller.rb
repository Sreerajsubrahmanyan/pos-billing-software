module Api
  class SalesController < ApplicationController
    include Authentication

    before_action :set_sale, only: [:show]

    # GET /api/sales
    # Admins can see all sales; staff can see their own sales.
    def index
      sales = if @current_user.role == "admin"
                Sale.includes(:sale_items).order(created_at: :desc)
              else
                Sale.where(user_id: @current_user.id)
                    .includes(:sale_items)
                    .order(created_at: :desc)
              end

      render json: sales.as_json(
        include: {
          sale_items: {
            include: { product: { only: [:id, :name, :sku] } },
            only: [:id, :product_id, :quantity, :unit_price, :total_price]
          },
          user: { only: [:id, :name, :email] }
        }
      ), status: :ok
    end

    # GET /api/sales/:id
    def show
      unless @current_user.role == "admin" ||
             @sale.user_id == @current_user.id
        render json: { error: "You cannot access this sale" },
               status: :forbidden
        return
      end

      render json: sale_response(@sale), status: :ok
    end

    # POST /api/sales
    def create
      items = params.dig(:sale, :items)

      if !items.is_a?(Array) || items.empty?
        render json: { error: "At least one product is required" },
               status: :unprocessable_entity
        return
      end

      payment_method = params.dig(:sale, :payment_method).to_s.downcase

      unless %w[cash card upi].include?(payment_method)
        render json: {
          error: "Payment method must be cash, card, or upi"
        }, status: :unprocessable_entity
        return
      end

      discount_input = params.dig(:sale, :discount_amount)
      discount = BigDecimal(discount_input.to_s.presence || "0")

      if !discount.finite? || discount.negative?
        render json: {
          error: "Discount must be a non-negative amount"
        }, status: :unprocessable_entity
        return
      end

      sale = nil

      Sale.transaction do
        # Lock products during checkout to prevent overselling.
        requested_items = items.map do |item|
          product_id = Integer(item[:product_id].to_s, 10)
          quantity = Integer(item[:quantity].to_s, 10)

          raise SaleProcessingError, "Quantity must be greater than zero" unless quantity.positive?

          product = Product.lock.find(product_id)

          if product.stock_quantity < quantity
            raise SaleProcessingError,
                  "Insufficient stock for #{product.name}"
          end

          {
            product: product,
            quantity: quantity,
            unit_price: BigDecimal(product.price.to_s)
          }
        end

        subtotal = requested_items.sum do |item|
          item[:unit_price] * item[:quantity]
        end

        if discount > subtotal
          raise SaleProcessingError,
                "Discount cannot exceed the subtotal"
        end

        # Tax is currently zero. We can add a configurable tax rate later.
        tax_amount = BigDecimal("0")
        total_amount = subtotal + tax_amount - discount

        sale = Sale.create!(
          user: @current_user,
          bill_number: generate_bill_number,
          subtotal: subtotal,
          tax_amount: tax_amount,
          discount_amount: discount,
          total_amount: total_amount,
          payment_method: payment_method,
          status: "completed"
        )

        requested_items.each do |item|
          product = item[:product]
          quantity = item[:quantity]
          unit_price = item[:unit_price]

          sale.sale_items.create!(
            product: product,
            quantity: quantity,
            unit_price: unit_price,
            total_price: unit_price * quantity
          )

          product.update!(
            stock_quantity: product.stock_quantity - quantity
          )
        end
      end

      render json: sale_response(sale.reload),
             status: :created

    rescue SaleProcessingError => e
      render json: { error: e.message },
             status: :unprocessable_entity
    rescue ActiveRecord::RecordNotFound
      render json: { error: "One or more products were not found" },
             status: :unprocessable_entity
    rescue ActiveRecord::RecordInvalid => e
      render json: {
        errors: e.record.errors.full_messages
      }, status: :unprocessable_entity
    rescue ArgumentError, TypeError
      render json: {
        error: "Invalid product ID, quantity, or amount"
      }, status: :unprocessable_entity
    end

    private

    class SaleProcessingError < StandardError; end

    def set_sale
      @sale = Sale.find_by(id: params[:id])

      return if @sale

      render json: { error: "Sale not found" },
             status: :not_found
    end

    def generate_bill_number
      "POS-#{Time.current.strftime('%Y%m%d')}-#{SecureRandom.hex(4).upcase}"
    end

    def sale_response(sale)
      sale.as_json(
        include: {
          sale_items: {
            include: {
              product: {
                only: [:id, :name, :sku]
              }
            },
            only: [
              :id, :product_id, :quantity,
              :unit_price, :total_price
            ]
          },
          user: {
            only: [:id, :name, :email]
          }
        }
      )
    end
  end
end
