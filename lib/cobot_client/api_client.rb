# frozen_string_literal: true

require 'rest_client'
require 'json'

module CobotClient
  class ApiClient
    include UrlHelper

    class << self
      attr_accessor :user_agent, :retry_time
    end
    self.retry_time = 1

    def initialize(access_token)
      @access_token = access_token
    end

    # args: either a full URL or subdomain, path, plus a body as hash
    def post(*args)
      request :post, *args
    end

    # args: either a full URL or subdomain, path, plus a body as hash
    def put(*args)
      request :put, *args
    end

    def patch(*args)
      request :patch, *args
    end

    # args: either a full URL or subdomain, path, plus an optional params hash
    def get(*args)
      url, subdomain, path, params = parse_args(*args)
      JSON.parse(
        rewrap_errors do
          RestClient.get(
            build_url(url || subdomain, path, params),
            headers
          ).body
        end, symbolize_names: true
      )
    end

    # args: either a full URL or subdomain, path
    def delete(*args)
      url, subdomain, path, = parse_args(*args)
      rewrap_errors do
        RestClient.delete(build_url(url || subdomain, path), headers)
      end
    end

    private

    def request(method, *args)
      url, subdomain, path, body = parse_args(*args)
      rewrap_errors do
        response = RestClient.public_send(method,
                                          build_url(url || subdomain, path),
                                          body.to_json,
                                          headers.merge(content_type_header))
        JSON.parse response.body, symbolize_names: true unless response.code == 204
      end
    end

    def rewrap_errors(&block)
      retry_errors(&block)
    rescue RestClient::Exception => e
      raise CobotClient::Exceptions::EXCEPTIONS_MAP[e.class], e.response
    end

    def retry_errors
      retries = 0
      begin
        yield
      rescue RestClient::BadGateway, SocketError, RestClient::RequestTimeout, CobotClient::InternalServerError => e
        raise e unless retries < 3

        sleep self.class.retry_time
        retries += 1
        retry
      end
    end

    # Returns [url, subdomain, path, params]
    def parse_args(*args)
      params = if args.size == 3 || (args.size == 2 && args[0].match(%r{https?://}))
                 args.pop
               else
                 {}
               end

      if args.size == 1
        [args[0], nil, nil, params]
      else
        [nil, args[0], args[1], params]
      end
    end

    def build_url(subdomain_or_url, path, params = {})
      if path
        cobot_url(subdomain_or_url, "/api#{path}", params: params)
      else
        uri = URI.parse(subdomain_or_url)
        uri.query = URI.encode_www_form(params) if params&.any?
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
