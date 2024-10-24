# frozen_string_literal: true

module ErrorHandler
  extend ActiveSupport::Concern

  included do
    rescue_from StandardError do |error|
      raise error if Rails.env.development?

      api_error = Value::Error::ApiError.new(error)
      Honeybadger.notify(error, context: error_context) if error_status == 500
      NewRelic::Agent.notice_error(error, expected:, custom_params: error_context)

      render json: api_error, status: error_status
    end
  end

  # When an exception has been raised but not yet handled
  # (in rescue, ensure, at_exit and END blocks), two global variables are set:
  # $! contains the current exception.
  # $@ contains its backtrace.
  def error_context
    context = $!.respond_to?(:honeybadger_context) ? $!.honeybadger_context : {}
    context.merge(jwt_token_data: try(:jwt_token_data))
  end

  def error_status
    return $!.http_code if $!.respond_to?(:http_code)

    ActionDispatch::ExceptionWrapper.status_code_for_exception($!.class.name)
  end

  def expected
    (400..499).cover? error_status
  end
end
