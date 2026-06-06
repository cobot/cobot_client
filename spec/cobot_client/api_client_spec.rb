# frozen_string_literal: true

require 'spec_helper'

describe CobotClient::ApiClient do
  let(:api_client) { described_class.new('token-123') }
  let(:default_response) { {status: 200, body: '{}'} }

  def cobot_client_response(code:, body: '')
    net_http_response = Net::HTTPResponse.new('1.1', code.to_s, nil)
    net_http_response.body = body
    net_http_response.instance_variable_set(:@read, true)

    CobotClient::Response.new(net_http_response)
  end

  before do
    described_class.user_agent = 'test agent'
    described_class.retry_time = 0
  end

  describe '#put' do
    it 'accepts a subdomain' do
      request = stub_request(:put, 'https://co-up.cobot.me/api/invoices')
                .with(
                  body: {id: '1'}.to_json,
                  headers: {
                    'Content-Type' => 'application/json',
                    'User-Agent' => 'test agent',
                    'Authorization' => 'Bearer token-123'
                  }
                )
                .and_return(default_response)

      api_client.put 'co-up', '/invoices', {id: '1'}

      expect(request).to have_been_made.once
    end

    it 'passes an array as body' do
      request = stub_request(:put, 'https://co-up.cobot.me/api/invoices')
                .with(
                  body: [{id: '1'}].to_json,
                  headers: {
                    'Content-Type' => 'application/json',
                    'User-Agent' => 'test agent',
                    'Authorization' => 'Bearer token-123'
                  }
                )
                .and_return(default_response)

      api_client.put 'co-up', '/invoices', [{id: '1'}]

      expect(request).to have_been_made.once
    end

    it 'accepts a url' do
      request = stub_request(:put, 'https://co-up.cobot.me/api/invoices')
                .with(
                  body: {id: '1'}.to_json,
                  headers: {
                    'Content-Type' => 'application/json',
                    'User-Agent' => 'test agent',
                    'Authorization' => 'Bearer token-123'
                  }
                )
                .and_return(default_response)

      api_client.put 'https://co-up.cobot.me/api/invoices', {id: '1'}

      expect(request).to have_been_made.once
    end

    it 'returns the response json' do
      allow_any_instance_of(CobotClient::Request).to receive(:submit) { cobot_client_response(code: 200, body: [{number: 1}].to_json) }

      expect(api_client.put('co-up', '/invoices', {})).to eql([{number: 1}])
    end

    it 'returns nil when the status code is 204' do
      allow_any_instance_of(CobotClient::Request).to receive(:submit) { cobot_client_response(body: '', code: 204) }

      expect(api_client.put('co-up', '/invoices', {})).to be_nil
    end

    it 'retries a 502 error' do
      times = 0
      allow_any_instance_of(CobotClient::Request).to receive(:submit) do
        if times < 3
          times += 1
          cobot_client_response(code: 502)
        else
          cobot_client_response(code: 200, body: {success: true}.to_json)
        end
      end

      expect(api_client.put('co-up', '/invoices', {})).to eql(success: true)
    end
  end

  describe '#patch' do
    it 'accepts a subdomain' do
      request = stub_request(:patch, 'https://co-up.cobot.me/api/invoices')
                .with(
                  body: {id: '1'}.to_json,
                  headers: {
                    'Content-Type' => 'application/json',
                    'User-Agent' => 'test agent',
                    'Authorization' => 'Bearer token-123'
                  }
                )
                .and_return(default_response)

      api_client.patch 'co-up', '/invoices', {id: '1'}

      expect(request).to have_been_made.once
    end

    it 'accepts a url' do
      request = stub_request(:patch, 'https://co-up.cobot.me/api/invoices')
                .with(
                  body: {id: '1'}.to_json,
                  headers: {
                    'Content-Type' => 'application/json',
                    'User-Agent' => 'test agent',
                    'Authorization' => 'Bearer token-123'
                  }
                )
                .and_return(default_response)

      api_client.patch 'https://co-up.cobot.me/api/invoices', {id: '1'}

      expect(request).to have_been_made.once
    end

    it 'returns the response json' do
      allow_any_instance_of(CobotClient::Request).to receive(:submit) { cobot_client_response(code: 200, body: [{number: 1}].to_json) }

      expect(api_client.patch('co-up', '/invoices', {})).to eql([{number: 1}])
    end

    it 'returns nil when the status code is 204' do
      allow_any_instance_of(CobotClient::Request).to receive(:submit) { cobot_client_response(body: '', code: 204) }

      expect(api_client.patch('co-up', '/invoices', {})).to be_nil
    end

    it 'retries a 502 error' do
      times = 0
      allow_any_instance_of(CobotClient::Request).to receive(:submit) do
        if times < 3
          times += 1
          cobot_client_response(code: 502)
        else
          cobot_client_response(code: 200, body: {success: true}.to_json)
        end
      end

      expect(api_client.patch('co-up', '/invoices', {})).to eql(success: true)
    end
  end

  describe '#post' do
    it 'accepts a subdomain' do
      request = stub_request(:post, 'https://co-up.cobot.me/api/invoices')
                .with(
                  body: {id: '1'}.to_json,
                  headers: {
                    'Content-Type' => 'application/json',
                    'User-Agent' => 'test agent',
                    'Authorization' => 'Bearer token-123'
                  }
                )
                .and_return(default_response)

      api_client.post 'co-up', '/invoices', {id: '1'}

      expect(request).to have_been_made.once
    end

    it 'accepts a url' do
      request = stub_request(:post, 'https://co-up.cobot.me/api/invoices')
                .with(
                  body: {id: '1'}.to_json,
                  headers: {
                    'Content-Type' => 'application/json',
                    'User-Agent' => 'test agent',
                    'Authorization' => 'Bearer token-123'
                  }
                )
                .and_return(default_response)

      api_client.post 'https://co-up.cobot.me/api/invoices', {id: '1'}

      expect(request).to have_been_made.once
    end

    it 'returns the response json' do
      allow_any_instance_of(CobotClient::Request).to receive(:submit) {
        cobot_client_response(code: 201, body: [{number: 1}].to_json)
      }

      expect(api_client.post('co-up', '/invoices', {})).to eql([{number: 1}])
    end

    it 'returns nil when the status code is 204' do
      allow_any_instance_of(CobotClient::Request).to receive(:submit) {
        cobot_client_response(code: 204, body: '')
      }

      expect(api_client.post('co-up', '/invoices', {})).to be_nil
    end
  end

  describe '#get' do
    it 'accepts a subdomain' do
      request = stub_request(:get, 'https://co-up.cobot.me/api/invoices?from=2013-10-6&to=2013-10-12')
                .with(headers:
                {
                  'User-Agent' => 'test agent',
                  'Authorization' => 'Bearer token-123'
                })
                .and_return(default_response)

      api_client.get 'co-up', '/invoices', {from: '2013-10-6', to: '2013-10-12'}

      expect(request).to have_been_made.once
    end

    it 'accepts a url' do
      request = stub_request(:get, 'https://co-up.cobot.me/api/invoices?from=2013-10-6&to=2013-10-12')
                .with(headers:
                {
                  'User-Agent' => 'test agent',
                  'Authorization' => 'Bearer token-123'
                })
                .and_return(default_response)

      api_client.get 'https://co-up.cobot.me/api/invoices', {from: '2013-10-6', to: '2013-10-12'}

      expect(request).to have_been_made.once
    end

    it 'returns the response json' do
      allow_any_instance_of(CobotClient::Request).to receive(:submit) { cobot_client_response(code: 200, body: [{number: 1}].to_json) }

      expect(api_client.get('co-up', '/invoices')).to eql([{number: 1}])
    end

    it 'converts a net/http error into a cobot error' do
      allow_any_instance_of(CobotClient::Request).to receive(:submit).and_raise(Timeout::Error.new)

      expect do
        api_client.get('co-up', '/invoices')
      end.to raise_error(CobotClient::ConnectionError)
    end

    it 'retries a Net::ReadTimeout' do
      stub_request(:get, 'https://co-up.cobot.me/api/invoices')
        .to_raise(Net::ReadTimeout.new)
        .to_return(status: 200, body: '{}')

      api_client.get('co-up', '/invoices')

      expect(a_request(:get, 'https://co-up.cobot.me/api/invoices')).to have_been_made.twice
    end

    it 'converts a Net::ReadTimeout into a CobotClient::ConnectionError' do
      allow_any_instance_of(CobotClient::Request).to receive(:submit).and_raise(Net::ReadTimeout.new)

      expect do
        api_client.get('co-up', '/invoices')
      end.to raise_error(CobotClient::ConnectionError, /^Net::ReadTimeout: /)
    end

    it 'includes the response, http code and http body in the exception' do
      response = cobot_client_response(code: 404, body: 'boom')
      error = response.to_error
      allow_any_instance_of(CobotClient::Request).to receive(:submit).and_raise(error)

      begin
        api_client.get('co-up', '/invoices')
      rescue CobotClient::ResponseError => e
        expect(e).to be_a(CobotClient::NotFound)
        expect(e.response).to eql(response)
        expect(e.http_code).to be(404)
        expect(e.http_body).to eql('boom')
      end
    end
  end

  describe '#delete' do
    it 'accepts a subdomain' do
      request = stub_request(:delete, 'https://co-up.cobot.me/api/invoices/1')
                .with(
                  headers: {
                    'User-Agent' => 'test agent',
                    'Authorization' => 'Bearer token-123'
                  }
                ).and_return(default_response)

      api_client.delete 'co-up', '/invoices/1'

      expect(request).to have_been_made.once
    end

    it 'accepts a url' do
      request = stub_request(:delete, 'https://co-up.cobot.me/api/invoices/1')
                .with(
                  headers: {
                    'User-Agent' => 'test agent',
                    'Authorization' => 'Bearer token-123'
                  }
                ).and_return(default_response)

      api_client.delete 'https://co-up.cobot.me/api/invoices/1'

      expect(request).to have_been_made.once
    end
  end
end
