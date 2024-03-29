# frozen_string_literal: true

require 'spec_helper'

describe CobotClient::ApiClient do
  let(:api_client) { described_class.new('token-123') }
  let(:default_response) { double(:default_response, code: 200, body: '{}') }

  before do
    described_class.user_agent = 'test agent'
    described_class.retry_time = 0
  end

  describe '#put' do
    it 'calls rest client' do
      expect(RestClient).to receive(:put).with(
        'https://co-up.cobot.me/api/invoices',
        {id: '1'}.to_json,
        {
          'Content-Type' => 'application/json',
          'User-Agent' => 'test agent',
          'Authorization' => 'Bearer token-123'
        }
      ) { default_response }

      api_client.put 'co-up', '/invoices', {id: '1'}
    end

    it 'passes an array as body' do
      expect(RestClient).to receive(:put).with(
        'https://co-up.cobot.me/api/invoices',
        [{id: '1'}].to_json,
        {
          'Content-Type' => 'application/json',
          'User-Agent' => 'test agent',
          'Authorization' => 'Bearer token-123'
        }
      ) { default_response }

      api_client.put 'co-up', '/invoices', [{id: '1'}]
    end

    it 'accepts a url' do
      expect(RestClient).to receive(:put).with(
        'https://co-up.cobot.me/api/invoices',
        {id: '1'}.to_json,
        {
          'Content-Type' => 'application/json',
          'User-Agent' => 'test agent',
          'Authorization' => 'Bearer token-123'
        }
      ) { default_response }

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
      times = 0
      allow(RestClient).to receive(:put) do
        if times < 3
          times += 1
          raise RestClient::BadGateway
        else
          double(code: 200, body: {success: true}.to_json)
        end
      end

      expect(api_client.put('co-up', '/invoices', {})).to eql(success: true)
    end
  end

  describe '#patch' do
    it 'calls rest client' do
      expect(RestClient).to receive(:patch).with(
        'https://co-up.cobot.me/api/invoices',
        {id: '1'}.to_json,
        {
          'Content-Type' => 'application/json',
          'User-Agent' => 'test agent',
          'Authorization' => 'Bearer token-123'
        }
      ) { default_response }

      api_client.patch 'co-up', '/invoices', {id: '1'}
    end

    it 'accepts a url' do
      expect(RestClient).to receive(:patch).with(
        'https://co-up.cobot.me/api/invoices',
        {id: '1'}.to_json,
        {
          'Content-Type' => 'application/json',
          'User-Agent' => 'test agent',
          'Authorization' => 'Bearer token-123'
        }
      ) { default_response }

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
      times = 0
      allow(RestClient).to receive(:patch) do
        if times < 3
          times += 1
          raise RestClient::BadGateway
        else
          double(code: 200, body: {success: true}.to_json)
        end
      end

      expect(api_client.patch('co-up', '/invoices', {})).to eql(success: true)
    end
  end

  describe '#post' do
    it 'calls rest client' do
      expect(RestClient).to receive(:post).with(
        'https://co-up.cobot.me/api/invoices',
        {id: '1'}.to_json,
        {
          'Content-Type' => 'application/json',
          'User-Agent' => 'test agent',
          'Authorization' => 'Bearer token-123'
        }
      ) { default_response }

      api_client.post 'co-up', '/invoices', {id: '1'}
    end

    it 'accepts a url' do
      expect(RestClient).to receive(:post).with(
        'https://co-up.cobot.me/api/invoices',
        {id: '1'}.to_json,
        {
          'Content-Type' => 'application/json',
          'User-Agent' => 'test agent',
          'Authorization' => 'Bearer token-123'
        }
      ) { default_response }

      api_client.post 'https://co-up.cobot.me/api/invoices', {id: '1'}
    end

    it 'returns the response json' do
      allow(RestClient).to receive(:post) {
                             double(:response,
                                    code: 201, body: [{number: 1}].to_json)
                           }

      expect(api_client.post('co-up', '/invoices', {})).to eql([{number: 1}])
    end

    it 'returns nil when the status code is 204' do
      allow(RestClient).to receive(:post) {
                             double(:response, code: 204,
                                               body: '')
                           }

      expect(api_client.post('co-up', '/invoices', {})).to be_nil
    end
  end

  describe '#get' do
    it 'calls rest client' do
      expect(RestClient).to receive(:get).with(
        'https://co-up.cobot.me/api/invoices?from=2013-10-6&to=2013-10-12',
        {
          'User-Agent' => 'test agent',
          'Authorization' => 'Bearer token-123'
        }
      ) { default_response }

      api_client.get 'co-up', '/invoices', {from: '2013-10-6', to: '2013-10-12'}
    end

    it 'accepts a url' do
      expect(RestClient).to receive(:get).with(
        'https://co-up.cobot.me/api/invoices?from=2013-10-6&to=2013-10-12',
        {
          'User-Agent' => 'test agent',
          'Authorization' => 'Bearer token-123'
        }
      ) { default_response }

      api_client.get 'https://co-up.cobot.me/api/invoices', {from: '2013-10-6', to: '2013-10-12'}
    end

    it 'returns the response json' do
      allow(RestClient).to receive(:get) { double(:response, body: [{number: 1}].to_json) }

      expect(api_client.get('co-up', '/invoices')).to eql([{number: 1}])
    end

    it 'converts a rest-client error into a cobot error' do
      allow(RestClient).to receive(:get).and_raise(RestClient::NotFound)

      expect do
        api_client.get('co-up', '/invoices')
      end.to raise_error(CobotClient::NotFound)
    end

    it 'retries a RestClient::RequestTimeout' do
      count = 0
      allow(RestClient).to receive(:get) do
        if count == 0
          count += 1
          raise RestClient::RequestTimeout
        else
          double(:response, body: '{}')
        end
      end

      expect(RestClient).to receive(:get).twice

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
      error = RestClient::NotFound.new(response)
      allow(RestClient).to receive(:get).and_raise(error)

      begin
        api_client.get('co-up', '/invoices')
      rescue CobotClient::NotFound => e
        expect(e.response).to eql(response)
        expect(e.http_code).to be(404)
        expect(e.http_body).to eql('boom')
      end
    end
  end

  describe '#delete' do
    it 'calls rest client' do
      expect(RestClient).to receive(:delete).with(
        'https://co-up.cobot.me/api/invoices/1',
        {
          'User-Agent' => 'test agent',
          'Authorization' => 'Bearer token-123'
        }
      ) { default_response }

      api_client.delete 'co-up', '/invoices/1'
    end

    it 'accepts a url' do
      expect(RestClient).to receive(:delete).with(
        'https://co-up.cobot.me/api/invoices/1',
        {
          'User-Agent' => 'test agent',
          'Authorization' => 'Bearer token-123'
        }
      ) { default_response }

      api_client.delete 'https://co-up.cobot.me/api/invoices/1'
    end
  end
end
