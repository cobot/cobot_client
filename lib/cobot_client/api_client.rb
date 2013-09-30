require 'rest_client'
require 'json'

module CobotClient
  class ApiClient
    include UrlHelper

    def initialize(access_token)
      @access_token = access_token
    end

    def get_resources(subdomain)
      get subdomain, '/resources'
    end

    def create_booking(subdomain, resource_id, attributes)
      post subdomain, "/resources/#{resource_id}/bookings", attributes
    end

    def update_booking(subdomain, id, attributes)
      put subdomain, "/bookings/#{id}", attributes
    end

    def delete_booking(subdomain, id)
      delete subdomain, "/bookings/#{id}"
    end

    private

    def put(subdomain, path, params)
      JSON.parse RestClient.put(cobot_url(subdomain, "/api#{path}"), params, auth_headers).body,
        symbolize_names: true
    end

    def delete(subdomain, path)
      RestClient.delete(cobot_url(subdomain, "/api#{path}"), auth_headers)
    end

    def post(subdomain, path, params)
      JSON.parse RestClient.post(cobot_url(subdomain, "/api#{path}"), params, auth_headers).body,
        symbolize_names: true
    end

    def get(subdomain, path)
      JSON.parse(
        RestClient.get(cobot_url(subdomain, "/api#{path}"), auth_headers).body,
        symbolize_names: true
      )
    end

    def auth_headers
      {'Authorization' => "Bearer #{@access_token}"}
    end
  end
end
