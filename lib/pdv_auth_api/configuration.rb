module PdvAuthApi
  class Configuration
    attr_accessor :api_key, :server_env, :auth_api_url

    def initialize
      @api_key = nil
      @server_env = 'sandbox'
      @auth_api_url = 'http://18.220.104.167'
    end
  end
end
