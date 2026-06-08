# frozen_string_literal: true

ENV['RBS_TEST_LOGLEVEL'] ||= 'error'
ENV['RBS_TEST_TARGET'] ||= 'CobotClient*'

require 'rbs/test/setup'

require_relative '../lib/cobot_client'

require 'webmock/rspec'
WebMock.disable_net_connect!
