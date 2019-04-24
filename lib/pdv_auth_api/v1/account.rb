module PdvAuthApi
  module V1
    class Account
      attr_accessor :token, :user

      def initialize(**params)
        assign_attributes(params)

        fetch if @token
      end

      def fetch
        authenticated_api.get 'account'
      end

      private

      def assign_attributes(params)
        @token = params[:token] if params[:token]
      end

      def authenticated_api
        PdvAuthApi::Connection.new(token: @token).api
      end
    end
  end
end
