# frozen_string_literal: true

module CobotClient
  class Response
    def initialize(net_http_response)
      @net_http_response = net_http_response
    end

    def body
      @net_http_response.body
    end

    def headers
      @net_http_response.to_hash
    end

    def code
      Integer(@net_http_response.code)
    end

    def parsed_body
      return if !success? || code == 204

      JSON.parse(@net_http_response.body, symbolize_names: true)
    rescue JSON::ParserError => e
      raise MalformedResponseBody.new("#{e.class}: #{e.message}", response: self)
    end

    def client_error?
      (400..499).cover?(code)
    end

    def server_error?
      (500..599).cover?(code)
    end

    def success?
      (200..299).cover?(code)
    end

    def to_error
      return if success?

      ResponseError.build(@net_http_response.message, response: self)
    end
  end
end
