require 'faraday'

module Faraday
  class SalsaRequestOverwrite < Faraday::Middleware
    def initialize(app)
      super(app)
    end

    def call(env)
      url = env[:url].to_s
      rewrite_request(env) if rewrite_request?(url)
      @app.call(env)
    end

    def rewrite_request?(url)
      url =~ /https:\/\/.*\.salsalabs\.com\/save/
    end

    def rewrite_request(env)
      url = env[:url].to_s
      env[:url] = URI(url.sub(/\/save\?/,'/save?xml&'))
    end
  end
end

if Faraday.respond_to?(:register_middleware)
  Faraday.register_middleware salsa: Faraday::SalsaRequestOverwrite
elsif Faraday::Middleware.respond_to?(:register_middleware)
  Faraday::Middleware.register_middleware salsa: Faraday::SalsaRequestOverwrite
end
