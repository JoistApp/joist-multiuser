# frozen_string_literal: true

module Value
  module Error
    class ApiError
      def initialize(exception)
        @exception = exception
      end

      # overriding the default as_json method
      # and ignoring _options
      def as_json(_options = {})
        {
          error: {
            code: code,
            message: message
          }
        }
      end

      # the type of exception
      def type
        @exception.class.to_s
      end

      # the code we will send to the caller
      def code
        code_hash[type] || if @exception.respond_to? :code
                             @exception.code
                           else
                             Codes::UNKNOWN
                           end
      end

      # the message we will send to the caller
      def message
        case type
        when "ActiveRecord::StatementInvalid"
          "Sorry there was a system error"
        when "ActiveRecord::RecordNotFound"
          "Record not found"
        when "ActiveRecord::RecordNotDestroyed"
          "Unable to delete record"
        when "ActiveRecord::RecordNotUnique"
          "Duplicate record"
        when "ActiveRecord::RecordInvalid"
          @exception.record.errors.full_messages.join(", ")
        else
          @exception.respond_to?(:user_friendly_message) ? @exception.user_friendly_message : @exception.message
        end
      end

      def code_hash
        {
          "ActiveRecord::RecordNotFound" => Codes::RECORD_NOT_FOUND,
          "ActiveRecord::RecordInvalid" => Codes::RECORD_INVALID,
          "ActiveRecord::RecordNotDestroyed" => Codes::RECORD_NOT_DESTROYED,
          "ActiveRecord::RecordNotUnique" => Codes::RECORD_NOT_UNIQUE,
          "ActiveRecord::StatementInvalid" => Codes::STATEMENT_INVALID,
          "ActionController::ParameterMissing" => Codes::PARAMETER_MISSING,
          "JoistSDK::Error::RestrictedAction" => Codes::JOIST_RESTRICTED_ACTION_ERROR,
          "Joist::Errors::Authorization" => Codes::JOIST_AUTHORIZATION_ERROR,
          "Joist::Errors::RecordNotFound" => Codes::JOIST_RECORD_NOT_FOUND,
          "Joist::Errors::RecordNotUnique" => Codes::JOIST_RECORD_NOT_UNIQUE,
          "JoistSDK::Api::Auth::Error::AccessControlError" => Codes::JOIST_AUTHORIZATION_ERROR
        }
      end
    end
  end
end
