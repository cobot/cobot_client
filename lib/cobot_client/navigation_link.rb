# frozen_string_literal: true

require 'virtus'

module CobotClient
  class NavigationLink
    include Virtus.model

    attribute :section, String
    attribute :label, String
    attribute :iframe_url, String
    attribute :user_url, String
    attribute :user_editable, Boolean, default: true
  end
end
