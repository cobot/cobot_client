require 'virtus'

class CobotClient::NavigationLink
  include Virtus

  attribute :section, String
  attribute :label, String
  attribute :iframe_url, String
  attribute :user_url, String
end
