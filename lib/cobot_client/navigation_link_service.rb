# frozen_string_literal: true

require 'oauth2'

module CobotClient
  # Used to install links into the Cobot navigation of a space.
  class NavigationLinkService
    # api_client - an CobotClient::ApiClient
    # access_token - an access token string (owner must be admin of the space to be used)
    def initialize(api_client, space_sudomain)
      @api_client = api_client
      @subdomain = space_sudomain
    end

    # Checks if links are already installed and if not installs them.
    #
    # new_links - any number of `CobotClient::NavigationLink`s
    #
    # Returns the links as `[CobotClient::NavigationLink]`
    def install_links(new_links)
      existing_links = fetch_links
      missing_links = new_links.reject do |new_link|
        existing_links.find do |existing_link|
          existing_link.section == new_link.section && existing_link.iframe_url == new_link.iframe_url
        end
      end
      created_links = missing_links.map do |link|
        create_link(link)
      end
      existing_links + created_links
    end

    private

    def fetch_links
      @api_client.get(@subdomain, '/navigation_links').map do |attributes|
        NavigationLink.new attributes
      end
    end

    def create_link(link)
      response = @api_client.post(
        @subdomain,
        '/navigation_links',
        section: link.section,
        label: link.label,
        iframe_url: link.iframe_url,
        user_editable: link.user_editable
      )

      NavigationLink.new response
    end
  end
end
