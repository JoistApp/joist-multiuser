# frozen_string_literal: true

module Devise
  module Strategies
    class JoistHeaderTokenStrategy < Devise::Strategies::Base
      def valid?
        ApiAuthorization::Token.valid?(token_value)
      end

      def authenticate!
        user = ApiAuthorization::Token.find_user!(token_value)

        if user && Devise.secure_compare(user.authentication_token, token_value)
          Rails.logger.debug "JoistHeaderTokenStrategy:: success!. User email: #{user ? user.email : "none"}, token_value: #{token_value}"
          success!(user)
        end

        unless halted?
          Rails.logger.info "JoistHeaderTokenStrategy:: not a success. User email: #{user ? user.email : "none"}, token_value: #{token_value}"
          fail("Invalid authentication token.")
        end
      rescue ActiveRecord::RecordNotFound
        Rails.logger.info "JoistHeaderTokenStrategy:: ActiveRecord::RecordNotFound token_value: #{token_value}"
        fail("Invalid authentication token.")
      end

      private

      def token_value
        # <int>:<alphanumeric string of length 20>
        ApiAuthorization::Header.token(header)
      end

      def header
        request.headers[ApiAuthorization::Header.key]
      end
    end
  end
end
