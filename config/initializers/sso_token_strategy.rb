# frozen_string_literal: true

module Devise
  module Strategies
    class SsoTokenStrategy < Devise::Strategies::Base
      def valid?
        token && provider
      end

      def authenticate!
        user = fetch_or_create_user_authentication&.user

        return fail!("Account not found, try to Sign Up instead.") unless user
        return fail!("This account has been suspended.") if user.banned?
        return fail!("For your security, your account has been locked for one hour.") if user.locked_at

        success!(user)
      rescue Sso::InvalidTokenError
        fail!("Invalid token, please try again.")
      rescue Sso::UndefinedProviderError, ActiveRecord::RecordNotFound
        fail!("Unsupported provider, please try different one.")
      end

      private

      def token
        params["user"]["token"]
      end

      def provider
        params["user"]["provider"]
      end

      def platform
        params["user"]["platform"].presence
      end

      def user_hash
        @user_hash ||= Sso::TokenValidator.call(token: token, provider: provider, platform: platform)
      end

      def authentication_provider
        @authentication_provider ||= AuthenticationProvider.find_by!(slug: provider)
      end

      def user_authentication
        UserAuthentication.find_by(external_user_id: user_hash[:external_user_id], authentication_provider: authentication_provider)
      end

      def fetch_or_create_user_authentication
        return user_authentication if user_authentication.present?

        user = User.find_by(email: user_hash[:email])
        return unless user

        UserAuthentication.create!(
          user: user,
          authentication_provider: authentication_provider,
          email: user_hash[:email],
          external_user_id: user_hash[:external_user_id]
        )
      end
    end
  end
end
