module Authentication
  extend ActiveSupport::Concern

  included do
    before_action :authenticate_user!
  end

  private

  def authenticate_user!
    token = request.headers["Authorization"]&.split(" ")&.last

    unless token.present?
      render json: { error: "Authentication token is required" },
             status: :unauthorized
      return
    end

    begin
      decoded_token = JWT.decode(
        token,
        Rails.application.secret_key_base,
        true,
        { algorithm: "HS256" }
      )

      user_id = decoded_token.first["user_id"]
      @current_user = User.find_by(id: user_id)

      unless @current_user
        render json: { error: "Invalid authentication token" },
               status: :unauthorized
      end
    rescue JWT::DecodeError, JWT::ExpiredSignature
      render json: { error: "Invalid or expired authentication token" },
             status: :unauthorized
    end
  end

  def require_admin!
    unless @current_user&.role == "admin"
      render json: { error: "Admin access required" },
             status: :forbidden
    end
  end
end