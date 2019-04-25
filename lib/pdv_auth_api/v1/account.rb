module PdvAuthApi
  module V1
    class Account
      attr_accessor :token, :user, :response, :errors

      def initialize(**params)
        assign_attributes(params)
      end

      def fetch(**params)
        assign_attributes(params)

        @response = authenticated_api.get 'account'

        body = JSON.parse(@response.body, symbolize_names: true)

        if @response.status == 200
          @user = body
          true
        else
          @errors = body[:errors]
          false
        end
      end

      def authenticated_api
        PdvAuthApi::Connection.new(token: @token).api
      end

      private

      def assign_attributes(params)
        @token = params[:token] if params[:token]
      end
    end
  end
end
