require 'faraday'

module PdvAuthApi
  class Connection
    attr_accessor :token

    def initialize(**params)
      assign_attributes(params)
    end

    def api(**params)
      assign_attributes(params)

      Faraday.new(url: "#{config.auth_api_url}/api/v1") do |faraday|
        faraday.response :logger
        faraday.adapter Faraday.default_adapter
        faraday.headers['Content-Type'] = 'application/json'
        faraday.headers['Api-Key'] = config.api_key

        faraday.headers['Authorization'] = "Token #{@token}" if @token
      end
    end

    private

    def assign_attributes(params)
      @token = params[:token] if params[:token]
    end

    def config
      PdvAuthApi.configuration
    end
  end
end
