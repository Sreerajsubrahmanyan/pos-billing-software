require "test_helper"

class Api::ReturnsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @admin = User.create!(name: "Returns Admin", email: "returns-admin@example.test",
                          password: "Password!123", role: "admin")
    @staff = User.create!(name: "Returns Staff", email: "returns-staff@example.test",
                          password: "Password!123", role: "staff")
    @product = Product.create!(name: "Test dress", sku: "TEST-RETURN-01",
                               price: 900, stock_quantity: 1)
    @sale = Sale.create!(user: @staff, bill_number: "TEST-RETURN-#{SecureRandom.hex(3)}",
                         subtotal: 1800, tax_amount: 0, discount_amount: 0,
                         total_amount: 1800, payment_method: "cash", status: "completed")
    @sale.sale_items.create!(product: @product, quantity: 2,
                             unit_price: 900, total_price: 1800)
  end

  test "return restores stock and refunds at the original unit price" do
    post "/api/returns", params: {
      return: { sale_id: @sale.id, product_id: @product.id, quantity: 1, reason: "Size or fit" }
    }, headers: auth_headers(@admin), as: :json

    assert_response :created
    assert_equal "900.0", response.parsed_body["refund_amount"]
    assert_equal 2, @product.reload.stock_quantity
  end

  test "returning more units than sold is rejected without changing stock" do
    post "/api/returns", params: {
      return: { sale_id: @sale.id, product_id: @product.id, quantity: 3, reason: "Changed mind" }
    }, headers: auth_headers(@admin), as: :json

    assert_response :unprocessable_entity
    assert_equal 1, @product.reload.stock_quantity
    assert_equal 0, Return.where(sale: @sale).count
  end

  test "staff cannot process returns" do
    post "/api/returns", params: {
      return: { sale_id: @sale.id, product_id: @product.id, quantity: 1, reason: "Size or fit" }
    }, headers: auth_headers(@staff), as: :json

    assert_response :forbidden
  end

  private

  def auth_headers(user)
    token = JWT.encode({ user_id: user.id, exp: 1.hour.from_now.to_i },
                       Rails.application.secret_key_base, "HS256")
    { "Authorization" => "Bearer #{token}" }
  end
end
