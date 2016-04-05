# CobotClient

[![Build Status](https://travis-ci.org/cobot/cobot_client.png?branch=master)](https://travis-ci.org/cobot/cobot_client)

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

    client = CobotClient::ApiClient.new <access token>
    CobotClient::NavigationLinkService.new(client, 'co-up').install_links [
      CobotClient::NavigationLink.new(section: 'admin/manage', label: 'My App', iframe_url: 'http://example.com')]

### Setting up automatic iframe resizing

When you install your app on Cobot you have to add the following to make sure the iframe on Cobot automatically gets resized according to the height of your page.

This only works for Ruby on Rails >= 3.2. If you are using anything else please take a look at the files involved and set it up manually.

Add this lines to your layout, before the closing `</body>` tag:

    <%= render 'cobot_client/resize_script' %>

This will automatically resize Cobot's iframe whenever a new page is loaded. To manually trigger a resize call `window.Cobot.iframeResize()`.

The default script determine's the iframe height by calling `jQuery('body').outerHeight()`. To provide your own height you can either pass it to the `iframeResize` function or you can define a function `window.Cobot.iframeHeight`.

When you display layers in the iframe that are positioned relative to the window you have to take into account how much the user scrolled down in the parent frame. For this purpose the script provides the property `window.Cobot.scrollTop`, which returns the no. of pixels the user has scrolled down.

### Generating URLs to the Cobot API

There is a module `CobotClient::UrlHelper`. After you include it you can call `cobot_url`. Examples:

    cobot_url('co-up') # => 'https://co-up.cobot.me/'
    cobot_url('co-up', '/api/user') # => 'https://co-up.cobot.me/api/user'
    cobot_url('co-up', '/api/user', params: {x: 'y'}) # => 'https://co-up.cobot.me/api/user?x=y'

### Calling the API

At the moment there are only a few high-level methods. For more details see the specs.

    client = CobotClient::ApiClient.new('<access token>')
    client.list_resources('<subdomain>')

For everything else you can use the low-level get/post/put/delete metods:

    client.get 'www', '/user'
    client.post 'my-subdomain', '/users', {"email": "joe@doe.com"}

You can also pass a URL instead of subdomain/path:

    client.get 'https://www/cobot.me/user'

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
