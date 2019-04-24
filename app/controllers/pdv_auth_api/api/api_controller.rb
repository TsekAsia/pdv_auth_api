module PdvAuthApi
  module Api
    class ApiController < ApplicationController
      def create
        auth = PdvAuthApi::V1::Auth.new(
          email: auth_params[:email], password: auth_params[:password]
        )

        if auth.login
          render json: { auth_token: auth.token }
        else
          render json: auth.errors, status: :unauthorized
        end
      end

      private

      def auth_params
        params.require(:auth).permit(:email, :password)
      end
    end
  end
end
