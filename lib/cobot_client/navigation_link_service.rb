require 'oauth2'

module CobotClient
  # Used to install links into the Cobot navigation of a space.
  class NavigationLinkService
    # oauth_client - an CobotClient::ApiClient
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
      if (links = get_links).empty?
        new_links.each do |link|
          links << create_link(link)
        end
      end
      links
    end

    private

    def get_links
      @api_client.get(@subdomain, "/navigation_links").map do |attributes|
        NavigationLink.new attributes
      end
    end

    def create_link(link)
      response = @api_client.post(@subdomain, '/navigation_links',
        section: link.section,
        label: link.label,
        iframe_url: link.iframe_url
      )

      NavigationLink.new response
    end
  end
end
