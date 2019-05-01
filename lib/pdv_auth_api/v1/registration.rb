require 'oj'

module PdvAuthApi
  module V1
    class Registration
      attr_accessor :email, :password_confirmation, :password, :errors,
                    :response, :user

      def initialize(**params)
        @email = params[:email]
        @password_confirmation = params[:password_confirmation]
        @password = params[:password]
      end

      def save!
        persist

        if @errors.nil?
          @user = JSON.parse(@response.body, symbolize_names: true)
          @user
        else
          false
        end
      end

      private

      attr_accessor :body

      def persist
        params = {
          user: {
            email: @email,
            password: @password,
            password_confirmation: @password_confirmation
          }
        }.to_json

        response = api.post 'registrations', params
        @response = response
        body = JSON.parse(@response.body, symbolize_names: true)

        @errors = body[:errors] || nil
      end

      def api
        PdvAuthApi::Connection.new.api
      end
    end
  end
end
