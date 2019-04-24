require 'faraday'

module PdvAuthApi
  class Connection
    def api(**params)
      Faraday.new(url: "#{config.auth_api_url}/api/v1") do |faraday|
        faraday.response :logger
        faraday.adapter Faraday.default_adapter
        faraday.headers['Content-Type'] = 'application/json'
        faraday.headers['Api-Key'] = config.api_key

        authorization = "Token #{params[:token]}" if params[:token]
        faraday.headers['Authorization'] = authorization if params[:token]
      end
    end

    private

    def config
      PdvAuthApi.configuration
    end
  end
end
