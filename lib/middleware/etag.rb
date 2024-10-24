# frozen_string_literal: true

module Middleware
  class Etag
    def initialize(app)
      @app = app
    end

    def call(env)
      request = HttpCacheable::Request.new(env)

      if request.cachable? && !request.modified?(env["ORIGINAL_FULLPATH"])
        # JoistLogging.debug "#{request.path} => HttpCacheable:: 304", {console: true}
        [304, {"ETag" => request.etag, "Cache-Control" => "private, must-revalidate, max-age=0"}, []]
      else
        # JoistLogging.debug "#{request.path} => HttpCacheable:: Call", {console: true}
        @app.call(env)
      end
    end
  end
end