require 'spec_helper'

describe CobotClient::NavigationLinkService, '#install_links' do
  let(:service) { CobotClient::NavigationLinkService.new(oauth_client, 'token-1', 'co-up') }
  let(:oauth_client) { double(:oauth_client) }

  before(:each) do
    @token = double(:token).as_null_object
    OAuth2::AccessToken.stub(new: @token)
  end

  context 'when there are links already' do
    before(:each) do
      @token.stub(:get).with('https://co-up.cobot.me/api/navigation_links') do double(:response, parsed: [
        {label: 'test link'}])
      end
    end

    it 'installs no links' do
      @token.should_not_receive(:post)

      service.install_links [double(:link)]
    end

    it 'returns the links' do
      expect(service.install_links([double(:link)]).map(&:label)).to eql(['test link'])
    end
  end

  context 'when there are no links installed' do
    let(:link) { double(:link, section: 'admin/manage', label: 'test link', iframe_url: '/test') }
    before(:each) do
      @token.stub(:get).with('https://co-up.cobot.me/api/navigation_links') { double(:response, parsed: []) }
    end

    it 'installs the links' do
      @token.should_receive(:post).with('https://co-up.cobot.me/api/navigation_links', body: {
        section: 'admin/manage', label: 'test link', iframe_url: '/test'
      }) { double(:response, status: 201, parsed: {}) }

      service.install_links [link]
    end

    it 'returns the links created' do
      response = double(:response, status: 201, parsed: {label: 'test link'})
      @token.stub(:post) { response }

      expect(service.install_links([link]).map(&:label)).to eql(['test link'])
    end
  end
end
