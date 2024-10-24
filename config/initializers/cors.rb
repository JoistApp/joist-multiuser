# frozen_string_literal: true

require "./lib/middleware/disable_cookie_session"
require "./lib/middleware/etag"

Rails.application.config.middleware.insert_before 0, Rack::Cors do
  CORS_ORIGINS = ENV.fetch("CORS_ORIGINS", "localhost:3000,localhost:4000")
  allow do
    origins CORS_ORIGINS.split(",").map(&:strip)

    resource "/api/v1/*",
             headers: :any,
             expose: %w[Link],
             methods: %i[get post delete put options head],
             max_age: 1_728_000
  end
end

Rails.application.config.middleware.insert_before Rack::Cors, Middleware::DisableCookieSession
Rails.application.config.middleware.insert_before Rack::Sendfile, Middleware::Etag
