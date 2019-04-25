module PdvAuthApi
  module Api
    class ApiController < ApplicationController
      before_action :authenticate_request

      private

      def authenticate_request
        auth_request = AuthorizeApiRequest.new(headers: request.headers)

        @current_user = auth_request.user if auth_request.valid?

        return if @current_user

        render json: { errors: auth_request.errors }, status: :unauthorized
      end
    end
  end
end
