# frozen_string_literal: true

require 'json'
require 'net/http'
require 'uri'

require 'active_model'

require 'cobot_client/version'
require 'cobot_client/engine' if defined?(Rails)
require 'cobot_client/errors'

module CobotClient
  autoload :ApiClient, 'cobot_client/api_client'
  autoload :NavigationLink, 'cobot_client/navigation_link'
  autoload :NavigationLinkService, 'cobot_client/navigation_link_service'
  autoload :Response, 'cobot_client/response'
  autoload :Request, 'cobot_client/request'
  autoload :UrlHelper, 'cobot_client/url_helper'
end
