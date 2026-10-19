require "test_helper"

class Api::LedgerControllerTest < ActionDispatch::IntegrationTest
  setup do
    @admin = User.create!(name: "Ledger Admin", email: "ledger-admin@example.test",
                          password: "Password!123", role: "admin")
    @cashier = User.create!(name: "Ledger Cashier", email: "ledger-cashier@example.test",
                            password: "Password!123", role: "staff")
    @product = Product.create!(name: "Ledger scarf", sku: "TEST-LEDGER-01",
                               price: 300, stock_quantity: 0)
    @sale = Sale.create!(user: @cashier, bill_number: "TEST-LEDGER-#{SecureRandom.hex(3)}",
                         subtotal: 600, tax_amount: 0, discount_amount: 0,
                         total_amount: 600, payment_method: "upi", status: "completed")
    @sale.sale_items.create!(product: @product, quantity: 2,
                             unit_price: 300, total_price: 600)
    Return.create!(sale: @sale, product: @product, user: @admin, quantity: 1,
                   refund_amount: 300, reason: "Size or fit")
  end

  test "admin ledger nets sales against refunds and includes both entries" do
    get "/api/ledger", headers: auth_headers(@admin), as: :json

    assert_response :success
    assert_equal "600.0", response.parsed_body["total_sales"]
    assert_equal "300.0", response.parsed_body["total_refunds"]
    assert_equal "300.0", response.parsed_body["net_cashflow"]
    assert_equal %w[return sale], response.parsed_body["entries"].map { |entry| entry["type"] }
  end

  test "staff cannot view the store ledger" do
    get "/api/ledger", headers: auth_headers(@cashier), as: :json

    assert_response :forbidden
  end

  private

  def auth_headers(user)
    token = JWT.encode({ user_id: user.id, exp: 1.hour.from_now.to_i },
                       Rails.application.secret_key_base, "HS256")
    { "Authorization" => "Bearer #{token}" }
  end
end
