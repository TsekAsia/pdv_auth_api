require 'pdv_auth_api/engine'
require 'pdv_auth_api/configuration'
require 'pdv_auth_api/connection'

require 'pdv_auth_api/v1/auth'
require 'pdv_auth_api/v1/registration'
require 'pdv_auth_api/v1/account'
require 'pdv_auth_api/v1/company'

module PdvAuthApi
  class << self
    attr_accessor :configuration

    def configuration
      @configuration ||= Configuration.new
    end

    def configure
      yield(configuration)
    end

    def reset
      @configuration = Configuration.new.api
    end
  end
end
