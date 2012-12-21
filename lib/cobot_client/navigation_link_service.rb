# Used to install links into the Cobot navigation of a space.
class CobotClient::NavigationLinkService
  include UrlHelper

  # oauth_client - an OAuth2::Client
  # access_token - an access token string (owner must be admin of the space to be used)
  def initialize(oauth_client, access_token, space_sudomain)
    @oauth_client = oauth_client
    @access_token = access_token
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
    token.get(cobot_url(@subdomain, "/api/navigation_links")).parsed.map do |attributes|
      NavigationLink.new attributes
    end
  end

  def create_link(link)
    response = token.post(cobot_url(@subdomain, '/api/navigation_links'), body: {
      section: link.section,
      label: link.label,
      iframe_url: link.iframe_url
    })

    unless successful?(response)
      raise "Error installing link: #{response.body}"
    end

    NavigationLink.new response.parsed
  end

  def token
    @token ||= OAuth2::AccessToken.new(@oauth_client, @access_token)
  end

  def successful?(response)
    [200, 201].include?(response.status)
  end
end
