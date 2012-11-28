require 'active_support/core_ext/module/attribute_accessors'
require 'uri'

module CobotClient::UrlHelper
  # set this to override the site for accessing the cobot api
  mattr_accessor :site

  # generates a url to access the cobot api
  # see the spec for usage examples
  def cobot_url(subdomain = 'www', *path_options)
    path = path_options.first.is_a?(String) ? path_options.first : '/'
    options = path_options.find{|p| p.is_a?(Hash)} || {}

    url = URI.parse(site || 'https://www.cobot.me')
    url.host = url.host.split('.').tap{|parts| parts[0] = subdomain}.join('.')
    url.path = path
    url.query = URI.encode_www_form(options[:params]) if options[:params]

    url.to_s
  end
end
