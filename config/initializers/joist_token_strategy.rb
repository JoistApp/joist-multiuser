# frozen_string_literal: true

module Devise
  module Strategies
    class JoistTokenStrategy < Devise::Strategies::Base
      def valid?
        ApiAuthorization::Token.valid?(params[:auth_token])
      end

      def store?
        false
      end

      def authenticate!
        user = ApiAuthorization::Token.find_user!(params[:auth_token])

        if user && Devise.secure_compare(user.authentication_token, params[:auth_token])
          Rails.logger.debug "JoistTokenStrategy:: success!. User email: #{user ? user.email : "none"}, token_value: #{params[:auth_token]}"
          success!(user)
        end

        unless halted?
          Rails.logger.info "JoistTokenStrategy:: not a success. User email: #{user ? user.email : "none"}, token_value: #{params[:auth_token]}"
          fail("Invalid authentication token.")
        end
      rescue ActiveRecord::RecordNotFound
        Rails.logger.info "JoistTokenStrategy:: ActiveRecord::RecordNotFound token_value: #{params[:auth_token]}"
        fail("Invalid authentication token.")
      end
    end
  end
end
