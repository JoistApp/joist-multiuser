# frozen_string_literal: true

module Infrastructure
  module ApiClient
    class Headers
      def self.make(request_user_agent:)
        {"User-Agent" => request_user_agent}
      end
    end
  end
end
