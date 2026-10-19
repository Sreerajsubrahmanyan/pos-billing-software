require "test_helper"

class Api::ProductsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @admin = User.create!(name: "Test Admin", email: "product-admin@example.test",
                          password: "Password!123", role: "admin")
    @staff = User.create!(name: "Test Staff", email: "product-staff@example.test",
                          password: "Password!123", role: "staff")
  end

  test "only an admin can create products" do
    params = { product: { name: "Silk scarf", sku: "TEST-PRODUCT-01", price: 499, stock_quantity: 4 } }
    post "/api/products", params:, headers: auth_headers(@staff), as: :json
    assert_response :forbidden

    post "/api/products", params:, headers: auth_headers(@admin), as: :json
    assert_response :created
    assert_equal "Silk scarf", response.parsed_body["name"]
  end

  private

  def auth_headers(user)
    { "Authorization" => "Bearer #{JWT.encode({ user_id: user.id, exp: 1.hour.from_now.to_i }, Rails.application.secret_key_base, "HS256")}" }
  end
end
