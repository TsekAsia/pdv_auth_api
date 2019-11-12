module PdvAuthApi
  module V1
    class App
      attr_accessor :app, :id, :name, :errors, :token

      def initialize(**params)
        assign_attributes(params)
      end

      class << self
        def find(**params)
          @response = authenticated_api.get "apps/#{params[:id]}"

          body = JSON.parse(@response.body, symbolize_names: true)

          return nil unless body[:exists]

          new(body[:app])
        end

        def subscriptions(**params)
          @response = authenticated_api.get "apps/#{params[:id]}/subscriptions"

          body = JSON.parse(@response.body, symbolize_names: true)

          return nil unless body[:exists]

          new(body[:app])
        end

        def my_app
          @response = authenticated_api.get 'apps/my_id'

          JSON.parse(@response.body, symbolize_names: true)
        end

        private

        def assign_attributes(params)
          params.each { |key, attr| try(:"#{key}=", attr) }
        end

        def authenticated_api
          PdvAuthApi::Connection.new(token: @token).api
        end
      end
    end
  end
end