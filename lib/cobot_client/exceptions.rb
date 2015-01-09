require 'rest_client'

module CobotClient
  module Exceptions
    EXCEPTIONS_MAP = {}
  end

  class Exception < RestClient::Exception
  end

  RestClient::STATUSES.each_pair do |code, message|
    superclass = RestClient::Exceptions::EXCEPTIONS_MAP.fetch code
    klass = Class.new(superclass)
    klass_constant = const_set message.delete(' \-\''), klass
    Exceptions::EXCEPTIONS_MAP[superclass] = klass_constant
  end
end
