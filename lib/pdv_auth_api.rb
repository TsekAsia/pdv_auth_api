require 'pdv_auth_api/engine'
require 'pdv_auth_api/configuration'

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
      @configuration = Configuration.new
    end
  end
end
