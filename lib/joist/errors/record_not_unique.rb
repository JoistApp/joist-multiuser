# frozen_string_literal: true

module Joist
  module Errors
    class RecordNotUnique < StandardError
      attr_reader :user_friendly_message

      def initialize(record_data, msg = "Duplicate record", friendly_msg = "Duplicate record")
        super(msg)
        @msg = msg
        @user_friendly_message = friendly_msg
        @record_data = record_data
      end

      def honeybadger_context
        @record_data.to_h
      end
    end
  end
end
