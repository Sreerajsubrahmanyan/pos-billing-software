module Api
  class LedgerController < ApplicationController
    include Authentication
    before_action :require_admin!

    def index
      from = params[:from].present? ? Date.iso8601(params[:from]) : 30.days.ago.to_date
      to = params[:to].present? ? Date.iso8601(params[:to]) : Date.current
      range = from.beginning_of_day..to.end_of_day
      sales = Sale.includes(:user).where(created_at: range)
      returns = Return.includes(:user, :sale, :product).where(created_at: range)

      entries = sales.map do |sale|
        { id: "sale-#{sale.id}", date: sale.created_at, type: "sale",
          reference: sale.bill_number, description: "Customer sale · #{sale.payment_method.upcase}",
          debit: 0, credit: sale.total_amount, staff: sale.user.name }
      end + returns.map do |record|
        { id: "return-#{record.id}", date: record.created_at, type: "return",
          reference: record.sale.bill_number, description: "Refund · #{record.product.name} · #{record.reason}",
          debit: record.refund_amount, credit: 0, staff: record.user.name }
      end
      entries.sort_by! { |entry| entry[:date] }.reverse!

      render json: {
        from: from, to: to,
        total_sales: sales.sum(:total_amount),
        total_refunds: returns.sum(:refund_amount),
        net_cashflow: sales.sum(:total_amount) - returns.sum(:refund_amount),
        entries: entries
      }
    rescue Date::Error
      render json: { error: "Dates must use YYYY-MM-DD format" }, status: :unprocessable_entity
    end
  end
end
