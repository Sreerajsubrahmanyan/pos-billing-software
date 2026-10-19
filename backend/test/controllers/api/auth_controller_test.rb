require "test_helper"

class Api::AuthControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = User.create!(name: "Test Admin", email: "test-admin@example.test",
                         password: "Password!123", role: "admin")
  end

  test "login returns a token and the user's role" do
    post "/api/login", params: { email: @user.email, password: "Password!123" }, as: :json

    assert_response :success
    assert_equal "admin", response.parsed_body.dig("user", "role")
    assert response.parsed_body["token"].present?
  end

  test "invalid credentials are rejected" do
    post "/api/login", params: { email: @user.email, password: "wrong" }, as: :json

    assert_response :unauthorized
    assert_equal "Invalid email or password", response.parsed_body["error"]
  end
end
