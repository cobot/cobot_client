require 'spec_helper'

describe CobotClient::ApiClient do
  let(:api_client) { CobotClient::ApiClient.new('token-123') }
  let(:default_response) { double(:default_response, code: 200, body: '{}') }

  before(:each) do
    CobotClient::ApiClient.user_agent = 'test agent'
    CobotClient::ApiClient.retry_time = 0
  end

  context 'listing resources' do
    it 'calls rest client' do
      expect(RestClient).to receive(:get).with('https://co-up.cobot.me/api/resources',
        hash_including('Authorization' => 'Bearer token-123')) { default_response }

      api_client.get_resources 'co-up'
    end

    it 'returns the json' do
      allow(RestClient).to receive(:get) { double(:response, body: [{id: 'resource-1'}].to_json) }

      resources = api_client.get_resources 'co-up'

      expect(resources).to eql([{id: 'resource-1'}])
    end
  end

  context 'creating a booking' do
    it 'calls rest client' do
      expect(RestClient).to receive(:post).with(
        'https://co-up.cobot.me/api/resources/res-1/bookings',
        {title: 'meeting'}.to_json,
        hash_including('Authorization' => 'Bearer token-123')) { default_response }

      api_client.create_booking 'co-up', 'res-1', title: 'meeting'
    end

    it 'returns the json' do
      allow(RestClient).to receive(:post) { double(:response,
        code: 201, body: {title: 'meeting'}.to_json) }

      booking = api_client.create_booking 'co-up', 'res-1', title: 'meeting'

      expect(booking).to eql({title: 'meeting'})
    end
  end

  context 'updating a booking' do
    it 'calls rest client' do
      expect(RestClient).to receive(:put).with('https://co-up.cobot.me/api/bookings/booking-1',
        {title: 'meeting'}.to_json,
        hash_including('Authorization' => 'Bearer token-123')) { default_response }

      api_client.update_booking 'co-up', 'booking-1', title: 'meeting'
    end

    it 'returns the json' do
      allow(RestClient).to receive(:put) { double(:response, code: 200,
        body: {title: 'meeting'}.to_json) }

      booking = api_client.update_booking 'co-up', 'booking-1', title: 'meeting'

      expect(booking).to eql({title: 'meeting'})
    end
  end

  context 'deleting a booking' do
    it 'calls rest client' do
      expect(RestClient).to receive(:delete).with('https://co-up.cobot.me/api/bookings/booking-1',
        hash_including('Authorization' => 'Bearer token-123')) { default_response }

      api_client.delete_booking 'co-up', 'booking-1'
    end
  end

  context '#put' do
    it 'calls rest client' do
      expect(RestClient).to receive(:put).with(
        'https://co-up.cobot.me/api/invoices',
        {id: '1'}.to_json,
        'Content-Type' => 'application/json',
          'User-Agent' => 'test agent',
          'Authorization' => 'Bearer token-123') { default_response }

      api_client.put 'co-up', '/invoices', {id: '1'}
    end

    it 'passes an array as body' do
      expect(RestClient).to receive(:put).with(
        'https://co-up.cobot.me/api/invoices',
        [{id: '1'}].to_json,
        'Content-Type' => 'application/json',
          'User-Agent' => 'test agent',
          'Authorization' => 'Bearer token-123') { default_response }

      api_client.put 'co-up', '/invoices', [{id: '1'}]
    end

    it 'accepts a url' do
      expect(RestClient).to receive(:put).with(
        'https://co-up.cobot.me/api/invoices',
        {id: '1'}.to_json,
        'Content-Type' => 'application/json',
          'User-Agent' => 'test agent',
          'Authorization' => 'Bearer token-123') { default_response }

      api_client.put 'https://co-up.cobot.me/api/invoices', {id: '1'}
    end

    it 'returns the response json' do
      allow(RestClient).to receive(:put) { double(:response, code: 200, body: [{number: 1}].to_json) }

      expect(api_client.put('co-up', '/invoices', {})).to eql([{number: 1}])
    end

    it 'returns nil when the status code is 204' do
      allow(RestClient).to receive(:put) { double(:response, body: '', code: 204) }

      expect(api_client.put('co-up', '/invoices', {})).to be_nil
    end

    it 'retries a 502 error' do
      @times = 0
      allow(RestClient).to receive(:put) do
        if @times < 3
          @times += 1
          fail RestClient::BadGateway
        else
          double(code: 200, body: {success: true}.to_json)
        end
      end

      expect(api_client.put('co-up', '/invoices', {})).to eql(success: true)
    end
  end

  context '#patch' do
    it 'calls rest client' do
      expect(RestClient).to receive(:patch).with(
        'https://co-up.cobot.me/api/invoices',
        {id: '1'}.to_json,
        'Content-Type' => 'application/json',
          'User-Agent' => 'test agent',
          'Authorization' => 'Bearer token-123') { default_response }

      api_client.patch 'co-up', '/invoices', {id: '1'}
    end

    it 'accepts a url' do
      expect(RestClient).to receive(:patch).with(
        'https://co-up.cobot.me/api/invoices',
        {id: '1'}.to_json,
        'Content-Type' => 'application/json',
          'User-Agent' => 'test agent',
          'Authorization' => 'Bearer token-123') { default_response }

      api_client.patch 'https://co-up.cobot.me/api/invoices', {id: '1'}
    end

    it 'returns the response json' do
      allow(RestClient).to receive(:patch) { double(:response, code: 200, body: [{number: 1}].to_json) }

      expect(api_client.patch('co-up', '/invoices', {})).to eql([{number: 1}])
    end

    it 'returns nil when the status code is 204' do
      allow(RestClient).to receive(:patch) { double(:response, body: '', code: 204) }

      expect(api_client.patch('co-up', '/invoices', {})).to be_nil
    end

    it 'retries a 502 error' do
      @times = 0
      allow(RestClient).to receive(:patch) do
        if @times < 3
          @times += 1
          fail RestClient::BadGateway
        else
          double(code: 200, body: {success: true}.to_json)
        end
      end

      expect(api_client.patch('co-up', '/invoices', {})).to eql(success: true)
    end
  end

  context '#post' do
    it 'calls rest client' do
      expect(RestClient).to receive(:post).with(
        'https://co-up.cobot.me/api/invoices',
        {id: '1'}.to_json,
        'Content-Type' => 'application/json',
          'User-Agent' => 'test agent',
          'Authorization' => 'Bearer token-123') { default_response }

      api_client.post 'co-up', '/invoices', {id: '1'}
    end

    it 'accepts a url' do
      expect(RestClient).to receive(:post).with(
        'https://co-up.cobot.me/api/invoices',
        {id: '1'}.to_json,
        'Content-Type' => 'application/json',
          'User-Agent' => 'test agent',
          'Authorization' => 'Bearer token-123') { default_response }

      api_client.post 'https://co-up.cobot.me/api/invoices', {id: '1'}
    end

    it 'returns the response json' do
      allow(RestClient).to receive(:post) { double(:response,
        code: 201, body: [{number: 1}].to_json) }

      expect(api_client.post('co-up', '/invoices', {})).to eql([{number: 1}])
    end

    it 'returns nil when the status code is 204' do
      allow(RestClient).to receive(:post) { double(:response, code: 204,
        body: '') }

      expect(api_client.post('co-up', '/invoices', {})).to be_nil
    end
  end

  context '#get' do
    it 'calls rest client' do
      expect(RestClient).to receive(:get).with('https://co-up.cobot.me/api/invoices?from=2013-10-6&to=2013-10-12',
        'User-Agent' => 'test agent', 'Authorization' => 'Bearer token-123') { default_response }

      api_client.get 'co-up', '/invoices', {from: '2013-10-6', to: '2013-10-12'}
    end

    it 'accepts a url' do
      expect(RestClient).to receive(:get).with('https://co-up.cobot.me/api/invoices?from=2013-10-6&to=2013-10-12',
        'User-Agent' => 'test agent', 'Authorization' => 'Bearer token-123') { default_response }

      api_client.get 'https://co-up.cobot.me/api/invoices', {from: '2013-10-6', to: '2013-10-12'}
    end

    it 'returns the response json' do
      allow(RestClient).to receive(:get) { double(:response, body: [{number: 1}].to_json) }

      expect(api_client.get('co-up', '/invoices')).to eql([{number: 1}])
    end

    it 'converts a rest-client error into a cobot error' do
      allow(RestClient).to receive(:get).and_raise(RestClient::ResourceNotFound)

      expect do
        api_client.get('co-up', '/invoices')
      end.to raise_error(CobotClient::ResourceNotFound)
    end

    it 'retries a RestClient::RequestTimeout' do
      count = 0
      allow(RestClient).to receive(:get) do
        if count == 0
          count += 1
          fail RestClient::RequestTimeout
        else
          double(:response, body: '{}')
        end
      end

      expect(RestClient).to receive(:get).exactly(2).times

      api_client.get('co-up', '/invoices')
    end

    it 'converts a RestClient::RequestTimeout into a CobotClient::RequestTimeout' do
      allow(RestClient).to receive(:get).and_raise(RestClient::RequestTimeout)

      expect do
        api_client.get('co-up', '/invoices')
      end.to raise_error(CobotClient::RequestTimeout)
    end

    it 'includes the response, http code and http body in the exception' do
      response = double(:response, code: 404, body: 'boom')
      error = RestClient::ResourceNotFound.new(response)
      allow(RestClient).to receive(:get).and_raise(error)

      begin
        api_client.get('co-up', '/invoices')
      rescue CobotClient::ResourceNotFound => e
        expect(e.response).to eql(response)
        expect(e.http_code).to eql(404)
        expect(e.http_body).to eql('boom')
      end
    end
  end

  context '#delete' do
    it 'calls rest client' do
      expect(RestClient).to receive(:delete).with(
        'https://co-up.cobot.me/api/invoices/1',
        'User-Agent' => 'test agent', 'Authorization' => 'Bearer token-123') { default_response }

      api_client.delete 'co-up', '/invoices/1'
    end

    it 'accepts a url' do
      expect(RestClient).to receive(:delete).with(
        'https://co-up.cobot.me/api/invoices/1',
        'User-Agent' => 'test agent', 'Authorization' => 'Bearer token-123') { default_response }

      api_client.delete 'https://co-up.cobot.me/api/invoices/1'
    end
  end
end
