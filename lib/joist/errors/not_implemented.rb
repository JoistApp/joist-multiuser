# frozen_string_literal: true

module Joist
  module Errors
    class NotImplemented < StandardError
      def initialize(msg = "This feature is not implemented")
        super
      end

      def http_code
        501
      end
    end
  end
end
