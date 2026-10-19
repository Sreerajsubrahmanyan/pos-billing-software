require "test_helper"

class Api::SalesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = User.create!(name: "Test Cashier", email: "cashier-test@example.test",
                         password: "Password!123", role: "staff")
    @product = Product.create!(name: "Test textile", sku: "TEST-SALE-01",
                               price: 125.50, stock_quantity: 5)
    @headers = { "Authorization" => "Bearer #{token_for(@user)}" }
  end

  test "checkout records a bill and decrements stock" do
    post "/api/sales", params: {
      sale: { items: [{ product_id: @product.id, quantity: 2 }],
              discount_amount: "10", payment_method: "UPI" }
    }, headers: @headers, as: :json

    assert_response :created
    assert_equal "241.0", response.parsed_body["total_amount"]
    assert_equal 3, @product.reload.stock_quantity
    assert_equal "upi", Sale.find_by!(bill_number: response.parsed_body["bill_number"]).payment_method
  end

  test "insufficient stock does not create a sale or alter inventory" do
    before_count = Sale.count
    post "/api/sales", params: {
      sale: { items: [{ product_id: @product.id, quantity: 6 }], payment_method: "cash" }
    }, headers: @headers, as: :json

    assert_response :unprocessable_entity
    assert_equal before_count, Sale.count
    assert_equal 5, @product.reload.stock_quantity
  end

  private

  def token_for(user)
    JWT.encode({ user_id: user.id, exp: 1.hour.from_now.to_i },
               Rails.application.secret_key_base, "HS256")
  end
end
