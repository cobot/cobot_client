# frozen_string_literal: true

require 'spec_helper'

describe CobotClient::NavigationLinkService do
  let(:service) { described_class.new(api_client, 'co-up') }
  let(:api_client) { instance_double(CobotClient::ApiClient) }

  context 'when there are links already' do
    let(:existing_link) do
      instance_double(
        CobotClient::NavigationLink,
        label: 'existing link',
        section: 'admin/setup',
        iframe_url: 'http://example.com/1'
      ).as_null_object
    end
    let(:new_link) do
      instance_double(
        CobotClient::NavigationLink,
        label: 'new link',
        section: 'admin/setup',
        iframe_url: 'http://example.com/2'
      ).as_null_object
    end

    before do
      allow(api_client).to receive(:get)
        .with('co-up', '/navigation_links')
        .and_return(
          [
            {
              label: 'existing link',
              section: 'admin/setup',
              iframe_url: 'http://example.com/1'
            }
          ]
        )
    end

    it 'installs the missing links' do
      expect(api_client).to receive(:post)
        .with(
          'co-up',
          '/navigation_links',
          hash_including(
            label: 'new link',
            section: 'admin/setup',
            iframe_url: 'http://example.com/2'
          )
        ).and_return({})

      service.install_links [existing_link, new_link]
    end

    it 'returns all the links' do
      allow(api_client).to receive(:post).and_return({label: 'new link'})

      expect(service.install_links([existing_link, new_link]).map(&:label)).to eql(['existing link', 'new link'])
    end
  end

  context 'when there are no links installed' do
    let(:link) do
      instance_double(CobotClient::NavigationLink,
                      section: 'admin/manage', label: 'test link', iframe_url: '/test',
                      user_editable: true)
    end

    before do
      allow(api_client).to receive(:get).with('co-up', '/navigation_links').and_return([])
    end

    it 'installs the links' do
      expect(api_client).to receive(:post)
        .with('co-up', '/navigation_links',
              section: 'admin/manage',
              label: 'test link',
              iframe_url: '/test',
              user_editable: true).and_return({})

      service.install_links [link]
    end

    it 'returns the links created' do
      allow(api_client).to receive(:post).and_return({label: 'test link'})

      expect(service.install_links([link]).map(&:label)).to eql(['test link'])
    end
  end
end
