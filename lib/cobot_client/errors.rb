# frozen_string_literal: true

module CobotClient
  class Error < StandardError; end

  class ConnectionError < Error; end

  class ResponseError < Error
    HTTP_CODE = nil

    attr_reader :response

    def self.build(msg = nil, response:)
      RESPONSE_CODE_TO_ERROR_CLASS
        .fetch(response.code, self)
        .new(msg, response: response)
    end

    def initialize(msg = nil, response: nil)
      @response = response

      super(
        [
          "HTTP #{http_code}",
          msg
        ].compact.join(' - ')
      )
    end

    def http_body
      @response&.body
    end

    def http_code
      @response&.code || self.class.const_get(:HTTP_CODE)
    end
  end

  RESPONSE_CODE_TO_ERROR_CLASS = ::Net::HTTPResponse::CODE_TO_OBJ.to_h do |code, net_http_class|
    class_name = net_http_class.name.delete_prefix('Net::HTTP')

    class_object = Class.new(ResponseError)
    class_object.const_get(:HTTP_CODE, code)

    [code.to_i, const_set(class_name, class_object)]
  end
end
