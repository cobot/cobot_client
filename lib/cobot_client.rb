require "cobot_client/version"
require 'cobot_client/engine' if defined?(Rails)

module CobotClient
  autoload :UrlHelper, 'cobot_client/url_helper'
  autoload :NavigationLink, 'cobot_client/navigation_link'
  autoload :NavigationLinkService, 'cobot_client/navigation_link_service'
  autoload :XdmHelper, 'cobot_client/xdm_helper'
end
