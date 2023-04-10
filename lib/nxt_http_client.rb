require "faraday"
require "faraday/httpclient"

class NxtHttpClient
  def initialize(url: nil, headers: {}, adapter: :typhoeus, json: false)
    headers = headers.merge(content_type: "application/json; charset=utf-8") if json
    @connection = ::Faraday.new(url:, headers:) do |connection|
      connection.adapter adapter

      if json
        connection.response :json
        connection.request :json
      end

      yield(connection) if block_given?
    end
  end

  %w[get delete head].each do |method|
    define_method(method) do |action, params: {}, headers: {}|
      @connection.send(method, action, params, headers)
    end
  end

  %w[post put patch delete].each do |method|
    define_method(method) do |action, **args|
      send_request(method:, action:, **args)
    end
  end

  private

  def send_request(method:, action:, body: nil, headers: {})
    @connection.send(method) do |request|
      request.url action
      request.headers = request.headers.merge(headers)
      request.body = body if body.present?
    end
  end
end
