# frozen_string_literal: true

module CobotClient
  class NavigationLink
    include ActiveModel::Model
    include ActiveModel::Attributes

    attribute :section, :string
    attribute :label, :string
    attribute :iframe_url, :string
    attribute :user_url, :string
    attribute :user_editable, :boolean, default: true
  end
end
