module PdvAuthApi
  module V1
    class Auth
      attr_accessor :response, :token, :email, :password, :errors

      def initialize(**params)
        assign_attributes(params)
      end

      def login(**params)
        assign_attributes(params)

        parameters = { auth: { email: @email, password: @password } }.to_json

        @response = api.post 'auth', parameters
        body = JSON.parse(@response.body, symbolize_names: true)

        if @response.status == 200
          @token = body[:auth_token]
          @token
        else
          @errors = body[:error]
          false
        end
      end

      def validate(**params)
        assign_attributes(params)

        @response = authenticated_api.post 'auth/validate'

        response.status == 200
      end

      private

      def assign_attributes(params)
        @email = params[:email] if params[:email]
        @password = params[:password] if params[:password]
        @token = params[:token] if params[:token]
      end

      def api
        PdvAuthApi::Connection.new.api
      end

      def authenticated_api
        PdvAuthApi::Connection.new(token: @token).api
      end
    end
  end
end
