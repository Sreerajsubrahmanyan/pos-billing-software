module Api
  class ReturnsController < ApplicationController
    include Authentication
    before_action :require_admin!

    def index
      returns = Return.includes(:product, :sale, :user).order(created_at: :desc)
      render json: returns.as_json(include: {
        product: { only: [:id, :name, :sku] },
        sale: { only: [:id, :bill_number] },
        user: { only: [:id, :name] }
      })
    end

    def create
      sale = Sale.find(params.require(:return).require(:sale_id))
      product = Product.find(params[:return][:product_id])
      raise ArgumentError, "Returns are accepted within 30 days of purchase" if sale.created_at < 30.days.ago

      quantity = Integer(params[:return][:quantity].to_s, 10)
      reason = params[:return][:reason].to_s.strip
      raise ArgumentError, "Quantity must be greater than zero" unless quantity.positive?
      raise ArgumentError, "A return reason is required" if reason.blank?
      raise ArgumentError, "Product was not on this bill" unless sale.sale_items.exists?(product_id: product.id)

      record = nil
      Sale.transaction do
        item = sale.sale_items.lock.find_by!(product_id: product.id)
        already_returned = Return.where(sale: sale, product: product).sum(:quantity)
        raise ArgumentError, "Return quantity exceeds the quantity sold" if quantity + already_returned > item.quantity
        refund = item.unit_price * quantity
        record = Return.create!(sale: sale, product: product, user: @current_user,
                                quantity: quantity, refund_amount: refund, reason: reason)
        product.lock!
        product.update!(stock_quantity: product.stock_quantity + quantity)
      end
      render json: record.as_json(include: { product: { only: [:id, :name, :sku] }, sale: { only: [:id, :bill_number] } }), status: :created
    rescue ActiveRecord::RecordNotFound
      render json: { error: "Sale or product not found" }, status: :not_found
    rescue ArgumentError, ActiveRecord::RecordInvalid => e
      render json: { error: e.message }, status: :unprocessable_entity
    end
  end
end
