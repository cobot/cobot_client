# frozen_string_literal: true

module CobotClient
  module UrlHelper
    DEFAULT_SITE = 'https://www.cobot.me'

    # set this to override the site for accessing the cobot api

    class << self
      def site
        @site || DEFAULT_SITE
      end

      attr_writer :site
    end

    # generates a uri to access the cobot api
    # see the spec for usage examples
    def cobot_uri(subdomain = 'www', path = '/', params: {}, **)
      uri = URI.parse(CobotClient::UrlHelper.site)
      uri.host = uri.host.split('.').tap { |parts| parts[0] = subdomain }.join('.')
      uri.path = path
      uri.query = URI.encode_www_form(params) unless params.empty?

      uri
    end

    def cobot_url(subdomain = 'www', path = '/', params: {}, **)
      cobot_uri(subdomain, path, params: params, **).to_s
    end
  end
end
