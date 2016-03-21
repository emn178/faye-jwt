if defined?(::Rails::Engine)
  module FayeJwt
    class Engine < ::Rails::Engine
      initializer "faye-jwt" do
        Rails.application.config.assets.precompile += %w( faye-jwt.js )
      end
    end
  end
end
