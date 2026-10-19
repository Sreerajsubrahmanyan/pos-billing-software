module Api
  class AuthController < ApplicationController
    def login
      user = User.find_by(email: params[:email].to_s.strip.downcase)

      if user&.authenticate(params[:password])
        token = JWT.encode(
          {
            user_id: user.id,
            exp: 24.hours.from_now.to_i
          },
          jwt_secret,
          "HS256"
        )

        render json: {
          token: token,
          user: {
            id: user.id,
            name: user.name,
            email: user.email,
            role: user.role
          }
        }, status: :ok
      else
        render json: { error: "Invalid email or password" },
               status: :unauthorized
      end
    end

    private

    def jwt_secret
      Rails.application.secret_key_base
    end
  end
end