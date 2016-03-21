# faye-jwt

[![Build Status](https://api.travis-ci.org/emn178/faye-jwt.png)](https://travis-ci.org/emn178/faye-jwt)
[![Coverage Status](https://coveralls.io/repos/emn178/faye-jwt/badge.svg?branch=master)](https://coveralls.io/r/emn178/faye-jwt?branch=master)

A gem that provides authentication by JWT(json web token) with faye.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'faye-jwt'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install faye-jwt

## Usage
faye-jwt will authenicate all requests by access token. If the access token can not be decoded, it will fail to authenicate.

### Server

For faye-rails, set up faye server in you initializers config, eg. `initializers/faye.rb`
```Ruby
Rails.application.config.middleware.use FayeRails::Middleware do
  add_extension(FayeJwt::Server.new('YOUR SECRET'))
  # others...
end
```

You can use jwt to generate access token and export it.
```Ruby
access_token = JWT.encode({:maybe => :userinfo}, 'YOUR SECRET')
```

#### Payload and Header
You can implement your custom server extension. You will get the decoded payload and header if you add your extension after faye-jwt.

```Ruby
class MyServer
  def incoming(message, callback)
    message['jwt']['payload'] // {"maybe" => "userinfo"}
    message['jwt']['header'] // eg. {"typ"=>"JWT", "alg"=>"HS256"}
    callback.call(message)
  end
end
```
And modify config
```Ruby
Rails.application.config.middleware.use FayeRails::Middleware do
  add_extension(FayeJwt::Server.new('YOUR SECRET'))
  add_extension(MyServer.new)
  # others...
end
```

### JavaScript Client
Require javascripts
```JavaScript
//= require faye
//= require faye-jwt
```
Add extension
```JavaScript
var client = new Faye.Client('/faye'); // Your faye path
client.addExtension(new FayeJWT.Client(access_token));
```

### Ruby Client
```Ruby
client = Faye::Client.new('http://localhost:3000/faye')
client.add_extension(FayeJwt::Client.new(access_token))
```

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

## Contact
The project's website is located at https://github.com/emn178/faye-jwt  
Author: Chen, Yi-Cyuan (emn178@gmail.com)
