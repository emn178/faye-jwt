require 'json'
require 'net/http'

module FayeJwt
  class Client
    attr_accessor :access_token

    def initialize(access_token)
      self.access_token = access_token
    end

    def outgoing(message, callback)
      message['Authorization'] = "Bearer #{access_token}"
      callback.call(message)
    end

    def incoming(message, callback)
      callback.call(message) if message['error'] != 'Authentication failed.'
    end

    def self.publish(url, channel, data, access_token)
      message = {'channel' => channel, 'data' => data, 'Authorization' => "Bearer #{access_token}"}
      uri = URI.parse(url)
      Net::HTTP.post_form(uri, message: [message].to_json).body
    end
  end
end
