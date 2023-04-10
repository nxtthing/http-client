require "faraday"
require "faraday/httpclient"

class NxtHttpClient
  def initialize(options: {}, base_url: nil, default_headers: {}, request: {})
    @connection = ::Faraday.new(
      url: base_url,
      headers: default_headers,
      request: request
    ) do |connection|
      configure_response_middlewares(connection, options)
      connection.adapter options[:adapter] || :typhoeus

      ssl_options = options[:ssl] || { verify: true, verify_mode: 0 }
      ssl_options.each do |k, v|
        connection.ssl[k] = v
      end
    end
  end

  def send_request(method:, url:, body: nil, headers: {})
    @connection.send(method) do |request|
      request.url url
      request.headers = request.headers.merge(headers)
      request.body = body if body.present?
    end
  end

  %w[get delete head].each do |method|
    define_method(method) do |path:, params: {}, headers: {}|
      @connection.send(method, path, params, headers)
    end
  end

  %w[post put patch delete].each do |method|
    define_method(method) do |**args|
      send_request(method: method, **args)
    end
  end

  private

  def configure_response_middlewares(connection, options)
    connection.request :multipart if options[:multipart]
    connection.request :url_encoded if options[:url_encoded]

    connection.response :logger if Rails.env.development? || options[:show_log]
    connection.response :json if options[:json_response]
    connection.response :raise_error if options[:raise_error]
  end
end
