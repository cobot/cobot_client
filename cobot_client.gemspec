# frozen_string_literal: true

require File.expand_path('lib/cobot_client/version', __dir__)

Gem::Specification.new do |gem|
  gem.authors       = ['Alexander Lang']
  gem.email         = ['alex@cobot.me']
  gem.description   = 'Client for the Cobot API plus helpers'
  gem.summary       = 'Client for the Cobot API plus helpers'
  gem.homepage      = 'http://github.com/cobot/cobot_client'
  gem.license       = 'MIT'

  gem.files         = `git ls-files`.split($OUTPUT_RECORD_SEPARATOR)
  gem.executables   = gem.files.grep(%r{^bin/}).map { |f| File.basename(f) }
  gem.name          = 'cobot_client'
  gem.require_paths = ['lib']
  gem.version       = CobotClient::VERSION

  gem.required_ruby_version = ['>=3.3', '<5']

  gem.add_dependency 'activemodel', '>=5.2'
  gem.add_dependency 'json', '~>2.0'
  gem.add_dependency 'oauth2', '~>2.0'

  gem.metadata['rubygems_mfa_required'] = 'true'
end
