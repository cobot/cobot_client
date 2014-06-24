require 'rest_client'
require 'json'

module CobotClient
  class ApiClient
    include UrlHelper

    class << self
      attr_accessor :user_agent
    end

    def initialize(access_token)
      @access_token = access_token
    end

    def get_resources(subdomain)
      get subdomain, '/resources'
    end

    def create_booking(subdomain, resource_id, attributes)
      post subdomain, "/resources/#{resource_id}/bookings", attributes
    end

    def update_booking(subdomain, id, attributes)
      put subdomain, "/bookings/#{id}", attributes
    end

    def delete_booking(subdomain, id)
      delete subdomain, "/bookings/#{id}"
    end

    # args: either a full URL or subdomain, path, plus a body as hash
    def put(*args)
      url, subdomain, path, body = parse_args *args
      JSON.parse RestClient.put(
          build_url(url || subdomain, path),
          body.to_json,
          headers.merge(content_type_header)).body,
        symbolize_names: true
    end

    # args: either a full URL or subdomain, path
    def delete(*args)
      url, subdomain, path, _ = parse_args *args
      RestClient.delete(build_url(url || subdomain, path), headers)
    end

    # args: either a full URL or subdomain, path, plus a body as hash
    def post(*args)
      url, subdomain, path, body = parse_args *args
      JSON.parse RestClient.post(
          build_url(url || subdomain, path),
          body.to_json,
          headers.merge(content_type_header)).body,
        symbolize_names: true
    end

    # args: either a full URL or subdomain, path, plus an optional params hash
    def get(*args)
      url, subdomain, path, params = parse_args *args
      JSON.parse(
        RestClient.get(
          build_url(url || subdomain, path, params),
          headers).body,
        symbolize_names: true
      )
    end

    private

    def parse_args(*args)
      if args.last.is_a?(Hash)
        params = args.pop
      else
        params = {}
      end
      if args.size == 1
        url = args[0]
        path = nil
        subdomain = nil
      else
        subdomain = args[0]
        path = args[1]
        url = nil
      end
      [url, subdomain, path, params]
    end

    def build_url(subdomain_or_url, path, params = {})
      if path
        cobot_url(subdomain_or_url, "/api#{path}", params: params)
      else
        uri = URI.parse(subdomain_or_url)
        uri.query = URI.encode_www_form(params) if params && params.any?
        uri.to_s
      end
    end

    def content_type_header
      {'Content-Type' => 'application/json'}
    end

    def headers
      {
        'Authorization' => "Bearer #{@access_token}",
        'User-Agent' => self.class.user_agent || "Cobot Client #{CobotClient::VERSION}"
      }
    end
  end
end
