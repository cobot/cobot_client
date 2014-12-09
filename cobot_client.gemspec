# -*- encoding: utf-8 -*-
require File.expand_path('../lib/cobot_client/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Alexander Lang"]
  gem.email         = ["alex@cobot.me"]
  gem.description   = %q{Client for the Cobot API plus helpers}
  gem.summary       = %q{Client for the Cobot API plus helpers}
  gem.homepage      = "http://github.com/cobot/cobot_client"
  gem.license       = 'MIT'

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "cobot_client"
  gem.require_paths = ["lib"]
  gem.version       = CobotClient::VERSION

  gem.add_dependency 'virtus', '~>1.0.0'
  gem.add_dependency 'oauth2', '~>1.0.0'
  gem.add_dependency 'rest-client', '~>1.7.0'
  gem.add_dependency 'json', '~>1.8.0'
  gem.add_development_dependency 'rspec', '~>3.0.0'
  gem.add_development_dependency 'rake'
end
