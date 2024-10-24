# frozen_string_literal: true

module Infrastructure
  module ApiClient
    class Data
      def self.make(user)
        return {} if user.blank?

        {
          user_id: user.id,
          company_id: user.company_id,
          country_code: "US"
        }
      end
    end
  end
end
