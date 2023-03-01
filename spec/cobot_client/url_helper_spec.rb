# frozen_string_literal: true

require 'spec_helper'

describe CobotClient::UrlHelper do
  let(:helper) do
    Object.new.tap do |o|
      o.extend described_class
    end
  end

  after do
    described_class.site = 'https://www.cobot.me'
  end

  it 'lets me change the site' do
    described_class.site = 'https://www.cobot.com'

    expect(helper.cobot_url).to eql('https://www.cobot.com/')
  end

  it 'returns the default url' do
    expect(helper.cobot_url).to eql('https://www.cobot.me/')
  end

  it 'returns a url with a sudomain' do
    expect(helper.cobot_url('co-up')).to eql('https://co-up.cobot.me/')
  end

  it 'returns a url with a path' do
    expect(helper.cobot_url('co-up', '/x/y')).to eql('https://co-up.cobot.me/x/y')
  end

  it 'returns a url with params' do
    expect(helper.cobot_url('co-up', params: {x: 'y'})).to eql('https://co-up.cobot.me/?x=y')
  end

  it 'returns a url with params and path' do
    expect(helper.cobot_url('co-up', '/x/y', params: {a: 'b'})).to eql('https://co-up.cobot.me/x/y?a=b')
  end
end
