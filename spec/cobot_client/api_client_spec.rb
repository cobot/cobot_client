require 'spec_helper'

describe CobotClient::ApiClient do
  let(:api_client) { CobotClient::ApiClient.new('token-123') }
  let(:default_response) { stub(:default_response, body: '{}') }

  context 'listing resources' do
    it 'calls rest client' do
      RestClient.should_receive(:get).with('https://co-up.cobot.me/api/resources',
        hash_including('Authorization' => 'Bearer token-123')) { default_response }

      api_client.get_resources 'co-up'
    end

    it 'returns the json' do
      RestClient.stub(:get) { stub(:response, body: [{id: 'resource-1'}].to_json) }

      resources = api_client.get_resources 'co-up'

      expect(resources).to eql([{id: 'resource-1'}])
    end
  end

  context 'creating a booking' do
    it 'calls rest client' do
      RestClient.should_receive(:post).with('https://co-up.cobot.me/api/resources/res-1/bookings',
        {title: 'meeting'},
        hash_including('Authorization' => 'Bearer token-123')) { default_response }

      api_client.create_booking 'co-up', 'res-1', title: 'meeting'
    end

    it 'returns the json' do
      RestClient.stub(:post) { stub(:response, body: {title: 'meeting'}.to_json) }

      booking = api_client.create_booking 'co-up', 'res-1', title: 'meeting'

      expect(booking).to eql({title: 'meeting'})
    end
  end

  context 'updating a booking' do
    it 'calls rest client' do
      RestClient.should_receive(:put).with('https://co-up.cobot.me/api/bookings/booking-1',
        {title: 'meeting'},
        hash_including('Authorization' => 'Bearer token-123')) { default_response }

      api_client.update_booking 'co-up', 'booking-1', title: 'meeting'
    end

    it 'returns the json' do
      RestClient.stub(:put) { stub(:response, body: {title: 'meeting'}.to_json) }

      booking = api_client.update_booking 'co-up', 'booking-1', title: 'meeting'

      expect(booking).to eql({title: 'meeting'})
    end
  end

  context 'deleting a booking' do
    it 'calls rest client' do
      RestClient.should_receive(:delete).with('https://co-up.cobot.me/api/bookings/booking-1',
        hash_including('Authorization' => 'Bearer token-123')) { default_response }

      api_client.delete_booking 'co-up', 'booking-1'
    end
  end

  context '#get' do
    it 'calls rest client' do
      RestClient.should_receive(:get).with('https://co-up.cobot.me/api/invoices?from=2013-10-6&to=2013-10-12',
        hash_including('Authorization' => 'Bearer token-123')) { default_response }

      api_client.get 'co-up', '/invoices', {from: '2013-10-6', to: '2013-10-12'}
    end

    it 'sends a user agent header' do
      CobotClient::ApiClient.user_agent = 'test agent'

      RestClient.should_receive(:get).with(anything,
        hash_including('User-Agent' => 'test agent')) { default_response }

      api_client.get 'co-up', '/invoices'
    end

    it 'returns the response json' do
      RestClient.stub(:get) { stub(:response, body: [{number: 1}].to_json) }

      expect(api_client.get('co-up', '/invoices')).to eql([{number: 1}])
    end
  end
end
