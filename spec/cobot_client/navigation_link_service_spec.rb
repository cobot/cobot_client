require 'spec_helper'

describe CobotClient::NavigationLinkService, '#install_links' do
  let(:service) { CobotClient::NavigationLinkService.new(oauth_client, 'token-1', 'co-up') }
  let(:oauth_client) { stub(:oauth_client) }

  before(:each) do
    @token = stub(:token).as_null_object
    OAuth2::AccessToken.stub(new: @token)
  end

  context 'when there are links already' do
    before(:each) do
      @token.stub(:get).with('https://co-up.cobot.me/api/navigation_links') do stub(:response, parsed: [
        {label: 'test link'}])
      end
    end

    it 'installs no links' do
      @token.should_not_receive(:post)

      service.install_links [stub(:link)]
    end

    it 'returns the links' do
      expect(service.install_links([stub(:link)]).map(&:label)).to eql(['test link'])
    end
  end

  context 'when there are no links installed' do
    let(:link) { stub(:link, section: 'admin/manage', label: 'test link', iframe_url: '/test') }
    before(:each) do
      @token.stub(:get).with('https://co-up.cobot.me/api/navigation_links') { stub(:response, parsed: []) }
    end

    it 'installs the links' do
      @token.should_receive(:post).with('https://co-up.cobot.me/api/navigation_links', body: {
        section: 'admin/manage', label: 'test link', iframe_url: '/test'
      }) { stub(:response, status: 201, parsed: {}) }

      service.install_links [link]
    end

    it 'returns the links created' do
      response = stub(:response, status: 201, parsed: {label: 'test link'})
      @token.stub(:post) { response }

      expect(service.install_links([link]).map(&:label)).to eql(['test link'])
    end
  end
end
