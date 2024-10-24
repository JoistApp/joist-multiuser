# frozen_string_literal: true

module Middleware
  class DisableCookieSession
    def initialize(app)
      @app = app
    end

    def call(env)
      api_request = env["REQUEST_PATH"] =~ %r{^/api/} && env["HTTP_ACCEPT"] =~ %r{^application/json$}

      status, headers, body = @app.call(env)

      # this will remove ALL cookies from the response
      # headers.delete 'Set-Cookie'
      # this will remove just your session cookie

      # Disable session cookie for JSON Api requests
      Rack::Utils.delete_cookie_header!(headers, "_joist_site_session") if api_request

      [status, headers, body]
    end
  end
end
