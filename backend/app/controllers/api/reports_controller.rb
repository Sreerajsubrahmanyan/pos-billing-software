module Api
  class ReportsController < ApplicationController
    include Authentication
    before_action :require_admin!

    def index
      from = params[:from].present? ? Date.iso8601(params[:from]) : 30.days.ago.to_date
      to = params[:to].present? ? Date.iso8601(params[:to]) : Date.current
      sales = Sale.where(created_at: from.beginning_of_day..to.end_of_day)
      render json: {
        from: from, to: to,
        sales_count: sales.count,
        gross_sales: sales.sum(:subtotal),
        discounts: sales.sum(:discount_amount),
        net_sales: sales.sum(:total_amount),
        returns: Return.where(created_at: from.beginning_of_day..to.end_of_day).sum(:refund_amount),
        low_stock: Product.where("stock_quantity <= ?", 5).order(:stock_quantity).limit(10),
        daily_sales: sales.group("DATE(created_at)").order("DATE(created_at)").sum(:total_amount).map { |date, amount| { date: date, amount: amount } },
        payment_methods: sales.group(:payment_method).count
      }
    rescue Date::Error
      render json: { error: "Dates must use YYYY-MM-DD format" }, status: :unprocessable_entity
    end
  end
end
