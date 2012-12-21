# CobotClient

A client for the [Cobot](http://cobot.me) [API](http://cobot.me/pages/api) plus helpers.

## Installation

Add this line to your application's Gemfile:

    gem 'cobot_client'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install cobot_client

## Usage

### Installing navigation links on Cobot:

You can install links to your app into the navigation on Cobot. When users click the link an iframe pointing to the given `iframe_url` will be shown.

    CobotClient::NavigationLinkService.new().install_links [
      CobotClient::NavigationLink.new(section: 'admin/manage', label: 'My App', iframe_url: 'http://example.com')]

### Setting up automatic iframe resizing

When you install your app on Cobot you have to add the following to make sure the iframe on Cobot automatically gets resized according to the height of your page.

This only works for Ruby on Rails >= 3.2. If you are using anything else please take a look at the files involved and set it up manually.

Add jQuery to your app.

Add this lines to your layout, before the closing `</body>` tag:

    <%= render 'cobot_client/resize_script' %>

Add this to your application.js:

    //= require cobot_client/easyxdm

Add the following code to your application controller:

    include CobotClient::XdmHelper

### Generating URLs to the Cobot API

There is a module `CobotClient::UrlHelper`. After you include it you can call `cobot_url`. Examples:

    cobot_url('co-up') # => 'https://co-up.cobot.me/'
    cobot_url('co-up', '/api/user') # => 'https://co-up.cobot.me/api/user'
    cobot_url('co-up', '/api/user', params: {x: 'y'}) # => 'https://co-up.cobot.me/api/user?x=y'

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
