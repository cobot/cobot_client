require 'uri'

module CobotClient::UrlHelper
  # set this to override the site for accessing the cobot api

  @@site = 'https://www.cobot.me'
  def self.site
    @@site
  end

  def self.site=(site)
    @@site = site
  end

  # generates a url to access the cobot api
  # see the spec for usage examples
  def cobot_url(subdomain = 'www', *path_options)
    path = path_options.first.is_a?(String) ? path_options.first : '/'
    options = path_options.find{|p| p.is_a?(Hash)} || {}

    url = URI.parse(CobotClient::UrlHelper.site)
    url.host = url.host.split('.').tap{|parts| parts[0] = subdomain}.join('.')
    url.path = path
    url.query = URI.encode_www_form(options[:params]) if options[:params] && options[:params].any?

    url.to_s
  end
end
