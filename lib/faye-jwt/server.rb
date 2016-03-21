require 'jwt'

module FayeJwt
  class Server
    attr_accessor :secret

    def initialize(secret)
      self.secret = secret
    end

    def incoming(message, callback)
      message['error'] = 'Authentication failed.' unless authenticate(message)
      callback.call(message)
    end

    def outgoing(message, callback)
      message.delete('Authorization')
      message.delete('jwt')
      callback.call(message)
    end

    def authenticate(message)
      payload, header = decode(message['Authorization'])
      return false if payload.nil?
      message['jwt'] = { 'payload' => payload, 'header' => header }
      true
    end

    def decode(authorization)
      return nil if authorization.nil?
      type, access_token = authorization.split(' ')
      return nil if type.to_s.downcase != 'bearer' || access_token.nil?
      JWT.decode(access_token, secret, true) rescue nil
    end
  end
end
