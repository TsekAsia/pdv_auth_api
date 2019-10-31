module PdvAuthApi
  module V1
    class App
      attr_accessor :app, :id, :name, :errors, :token

      class << self
        def find(**params)
          @response = api.get "apps/#{params[:id]}"

          body = JSON.parse(@response.body, symbolize_names: true)

          return nil unless body[:exists]

          new(body[:app])
        end

        private

        def api
          PdvAuthApi::Connection.new.api
        end
      end
    end
  end
end
