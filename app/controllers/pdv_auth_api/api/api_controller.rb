module PdvAuthApi
  module Api
    class ApiController < ApplicationController
      include PdvAuthApi::Api::Concerns::Permissions

      before_action :authenticate_request
      before_action :initiate_company

      private

      def authenticate_request
        auth_request = AuthorizeApiRequest.new(headers: request.headers)

        @current_user = auth_request.user if auth_request.valid?

        return if @current_user

        render json: { errors: 'Login required.' }, status: :unauthorized
      end

      def initiate_company
        return unless @current_user

        @company = PdvAuthApi::V1::Company.new(account: @current_user)
      end
    end
  end
end
