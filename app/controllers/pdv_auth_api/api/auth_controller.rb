module PdvAuthApi
  module Api
    class AuthController < ApiController
      before_action :authenticate_request

    private

    def authenticate_request
      auth_request = AuthorizeApiRequest.new(headers: request.headers)

      return if auth_request.valid?

      render json: { errors: auth_request.errors }, status: :unauthorized
    end
  end
end
