# frozen_string_literal: true

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
    def post(*)
      request(:post, *).parsed_body
    end

    # args: either a full URL or subdomain, path, plus a body as hash
    def put(*)
      request(:put, *).parsed_body
    end

    def patch(*)
      request(:patch, *).parsed_body
    end

    # args: either a full URL or subdomain, path, plus an optional params hash
    def get(*)
      request(:get, *).parsed_body
    end

    # args: either a full URL or subdomain, path
    def delete(*)
      request(:delete, *)
    end

    private

    def request(method, *)
      request = Request.new(method, *)
      request.headers = headers

      retry_errors do
        request.submit
      end
    end

    def rewrap_errors
      yield.tap do |response|
        raise response.to_error if response.client_error? || response.server_error?
      end
    rescue Net::ProtocolError, SocketError, Timeout::Error => e
      raise ConnectionError, "#{e.class}: #{e.message}"
    end

    def retry_errors(&)
      retries = 0
      begin
        rewrap_errors(&)
      rescue ConnectionError, BadGateway, InternalServerError => e
        raise e unless retries < 3

        sleep self.class.retry_time
        retries += 1
        retry
      end
    end

    def headers
      {
        'Authorization' => "Bearer #{@access_token}",
        'User-Agent' => self.class.user_agent || "Cobot Client #{CobotClient::VERSION}"
      }
    end
  end
end
