require "cobot_client/version"
require 'cobot_client/engine' if defined?(Rails)
require 'cobot_client/exceptions'

module CobotClient
  autoload :ApiClient, 'cobot_client/api_client'
  autoload :NavigationLink, 'cobot_client/navigation_link'
  autoload :NavigationLinkService, 'cobot_client/navigation_link_service'
  autoload :UrlHelper, 'cobot_client/url_helper'
  autoload :XdmHelper, 'cobot_client/xdm_helper'
end
