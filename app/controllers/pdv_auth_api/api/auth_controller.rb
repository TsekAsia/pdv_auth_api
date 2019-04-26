module PdvAuthApi
  module Api
    class AuthController < ApiController
      skip_before_action :authenticate_request, only: :create

      def create
        auth = PdvAuthApi::V1::Auth.new(
          email: auth_params[:email], password: auth_params[:password]
        )

        if auth.login
          render json: { auth_token: auth.token }
        else
          render json: { errors: auth.errors }, status: :unauthorized
        end
      end

      def validate
        render json: { message: 'Token is valid' }, status: :ok
      end

      private

      def auth_params
        params.require(:auth).permit(:email, :password)
      end
    end
  end
end
