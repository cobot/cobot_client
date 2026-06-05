# frozen_string_literal: true

module CobotClient
  class Request
    include UrlHelper

    CONTENT_TYPE_HEADER = {'Content-Type' => 'application/json'}.freeze
    VERBS = %i[get post put patch delete].freeze

    attr_reader :body, :headers, :uri, :verb

    def initialize(verb, *)
      raise ArgumentError, "Unsupported verb: #{verb.inspect}" unless VERBS.include?(verb)

      @verb = verb
      @headers = CONTENT_TYPE_HEADER

      url, subdomain, path, params = parse_args(*)
      @uri, @body = case @verb
                    when :get, :delete
                      [build_uri(url || subdomain, path, **params), nil]
                    else
                      [build_uri(url || subdomain, path), params.to_json]
                    end
    end

    def headers=(headers)
      raise ArgumentError, "Expected Hash, got: #{headers.inspect}" unless headers.is_a?(Hash)

      @headers = headers.merge(CONTENT_TYPE_HEADER)
    end

    def submit
      Response.new(
        http.request(net_http_request)
      )
    end

    private

    def build_uri(subdomain_or_url, path, **params)
      if path
        cobot_uri(subdomain_or_url, "/api#{path}", params: params)
      else
        uri = URI.parse(subdomain_or_url)
        uri.query = URI.encode_www_form(params) unless params.empty?
        uri
      end
    end

    def http
      @http ||= Net::HTTP.new(uri.host, uri.port).tap do |http|
        http.use_ssl = (uri.scheme == 'https')
      end
    end

    # Do not memoize this because `headers` can change
    def net_http_request
      request_class.new(uri).tap do |request|
        request.body = body if body
        request.initialize_http_header(headers)
      end
    end

    def request_class
      case @verb
      when :get then Net::HTTP::Get
      when :post then Net::HTTP::Post
      when :put then Net::HTTP::Put
      when :patch then Net::HTTP::Patch
      when :delete then Net::HTTP::Delete
      end
    end

    def parse_args(*args)
      params = if args.size == 3 || (args.size == 2 && args[0].match(%r{https?://}))
                 args.pop
               else
                 {}
               end

      if args.size == 1
        [args[0], nil, nil, params]
      else
        [nil, args[0], args[1], params]
      end
    end
  end
end
