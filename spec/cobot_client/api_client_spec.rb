require 'spec_helper'

describe CobotClient::ApiClient do
  let(:api_client) { CobotClient::ApiClient.new('token-123') }
  let(:default_response) { double(:default_response, body: '{}') }

  before(:each) do
    CobotClient::ApiClient.user_agent = 'test agent'
  end

  context 'listing resources' do
    it 'calls rest client' do
      RestClient.should_receive(:get).with('https://co-up.cobot.me/api/resources',
        hash_including('Authorization' => 'Bearer token-123')) { default_response }

      api_client.get_resources 'co-up'
    end

    it 'returns the json' do
      RestClient.stub(:get) { double(:response, body: [{id: 'resource-1'}].to_json) }

      resources = api_client.get_resources 'co-up'

      expect(resources).to eql([{id: 'resource-1'}])
    end
  end

  context 'creating a booking' do
    it 'calls rest client' do
      RestClient.should_receive(:post).with(
        'https://co-up.cobot.me/api/resources/res-1/bookings',
        {title: 'meeting'}.to_json,
        hash_including('Authorization' => 'Bearer token-123')) { default_response }

      api_client.create_booking 'co-up', 'res-1', title: 'meeting'
    end

    it 'returns the json' do
      RestClient.stub(:post) { double(:response, body: {title: 'meeting'}.to_json) }

      booking = api_client.create_booking 'co-up', 'res-1', title: 'meeting'

      expect(booking).to eql({title: 'meeting'})
    end
  end

  context 'updating a booking' do
    it 'calls rest client' do
      RestClient.should_receive(:put).with('https://co-up.cobot.me/api/bookings/booking-1',
        {title: 'meeting'}.to_json,
        hash_including('Authorization' => 'Bearer token-123')) { default_response }

      api_client.update_booking 'co-up', 'booking-1', title: 'meeting'
    end

    it 'returns the json' do
      RestClient.stub(:put) { double(:response, body: {title: 'meeting'}.to_json) }

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

  context '#put' do
    it 'calls rest client' do
      RestClient.should_receive(:put).with(
        'https://co-up.cobot.me/api/invoices',
        {id: '1'}.to_json,
        'Content-Type' => 'application/json',
          'User-Agent' => 'test agent',
          'Authorization' => 'Bearer token-123') { default_response }

      api_client.put 'co-up', '/invoices', {id: '1'}
    end

    it 'returns the response json' do
      RestClient.stub(:put) { double(:response, body: [{number: 1}].to_json) }

      expect(api_client.put('co-up', '/invoices', {})).to eql([{number: 1}])
    end
  end

  context '#post' do
    it 'calls rest client' do
      RestClient.should_receive(:post).with(
        'https://co-up.cobot.me/api/invoices',
        {id: '1'}.to_json,
        'Content-Type' => 'application/json',
          'User-Agent' => 'test agent',
          'Authorization' => 'Bearer token-123') { default_response }

      api_client.post 'co-up', '/invoices', {id: '1'}
    end

    it 'returns the response json' do
      RestClient.stub(:post) { double(:response, body: [{number: 1}].to_json) }

      expect(api_client.post('co-up', '/invoices', {})).to eql([{number: 1}])
    end
  end

  context '#get' do
    it 'calls rest client' do
      RestClient.should_receive(:get).with('https://co-up.cobot.me/api/invoices?from=2013-10-6&to=2013-10-12',
        'User-Agent' => 'test agent', 'Authorization' => 'Bearer token-123') { default_response }

      api_client.get 'co-up', '/invoices', {from: '2013-10-6', to: '2013-10-12'}
    end

    it 'returns the response json' do
      RestClient.stub(:get) { double(:response, body: [{number: 1}].to_json) }

      expect(api_client.get('co-up', '/invoices')).to eql([{number: 1}])
    end
  end

  context '#delete' do
    it 'calls rest client' do
      RestClient.should_receive(:delete).with(
        'https://co-up.cobot.me/api/invoices/1',
        'User-Agent' => 'test agent', 'Authorization' => 'Bearer token-123') { default_response }

      api_client.delete 'co-up', '/invoices/1'
    end
  end
end
