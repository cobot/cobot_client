require 'spec_helper'

describe CobotClient::NavigationLinkService, '#install_links' do
  let(:service) { CobotClient::NavigationLinkService.new(api_client, 'co-up') }
  let(:api_client) { instance_double(CobotClient::ApiClient) }

  context 'when there are links already' do
    before(:each) do
      allow(api_client).to receive(:get)
        .with('co-up', '/navigation_links') { [{label: 'test link'}] }
    end

    it 'installs no links' do
      expect(api_client).to_not receive(:post)

      service.install_links [double(:link)]
    end

    it 'returns the links' do
      expect(service.install_links([double(:link)]).map(&:label)).to eql(['test link'])
    end
  end

  context 'when there are no links installed' do
    let(:link) do
      instance_double(CobotClient::NavigationLink,
        section: 'admin/manage', label: 'test link', iframe_url: '/test',
        user_editable: true)
    end

    before(:each) do
      allow(api_client).to receive(:get).with('co-up', '/navigation_links') { [] }
    end

    it 'installs the links' do
      expect(api_client).to receive(:post)
        .with('co-up', '/navigation_links',
          section: 'admin/manage',
          label: 'test link',
          iframe_url: '/test',
          user_editable: true) { {} }

      service.install_links [link]
    end

    it 'returns the links created' do
      allow(api_client).to receive(:post) { {label: 'test link'} }

      expect(service.install_links([link]).map(&:label)).to eql(['test link'])
    end
  end
end
