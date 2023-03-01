# frozen_string_literal: true

require 'rest_client'

module CobotClient
  class Exception < RestClient::Exception; end

  module Exceptions; end

  Exceptions::EXCEPTIONS_MAP = RestClient::STATUSES.each_with_object({}) do |(code, message), hash|
    superclass = RestClient::Exceptions::EXCEPTIONS_MAP.fetch code
    klass = Class.new(superclass)
    klass_constant = const_set message.delete(' \-\''), klass
    hash[superclass] = klass_constant
  end
end
