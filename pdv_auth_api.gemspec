$LOAD_PATH.push File.expand_path('lib', __dir__)

# Maintain your gem's version:
require 'pdv_auth_api/version'

# Describe your gem and declare its dependencies:
Gem::Specification.new do |spec|
  spec.name        = 'pdv_auth_api'
  spec.version     = PdvAuthApi::VERSION
  spec.authors     = ['Marc Dagatan']
  spec.email       = ['marc.dagatan@gmail.com']
  spec.homepage    = 'http://full-suite.com'
  spec.summary     = 'PDV Auth Api wrapper gem'
  spec.description = 'A wrapper gem for PDV Auth Api, for internal use only.'
  spec.license     = 'MIT'

  # Prevent pushing this gem to RubyGems.org.
  # To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow
  # pushing to any host.

  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com'"
  else
    raise 'RubyGems 2.0 or newer is required to protect against ' \
      'public gem pushes.'
  end

  spec.files = Dir[
    '{app,config,db,lib}/**/*',
    'MIT-LICENSE',
    'Rakefile',
    'README.md'
  ]

  spec.add_dependency 'faraday'
  spec.add_dependency 'oj'
  spec.add_dependency 'rails', '~> 5.2.3'

  spec.add_development_dependency 'rspec-rails'
  spec.add_development_dependency 'rubocop'
  spec.add_development_dependency 'rubocop-performance'
  spec.add_development_dependency 'sqlite3'
  spec.add_development_dependency 'vcr'
  spec.add_development_dependency 'webmock'
end
