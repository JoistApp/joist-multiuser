# frozen_string_literal: true

module TokenAuthenticatable
  extend ActiveSupport::Concern

  def self.included(base)
    base.class_eval do
      base.extend(ClassMethods)

      # After create due to requiring the users id
      after_create do
        reset_authentication_token!
      end
    end
  end

  module ClassMethods
    def find_by_authentication_token(authentication_token = nil)
      return unless authentication_token

      where(authentication_token: authentication_token).first
    end

    def token_prefix
      ""
    end
  end

  def ensure_authentication_token
    return if authentication_token.present?

    self.authentication_token = generate_authentication_token
  end

  def reset_authentication_token!
    self.authentication_token = generate_authentication_token
    save
  end

  private

  def generate_authentication_token
    loop do
      token = Devise.friendly_token
      break "#{self.class.token_prefix}#{id}:#{token}" unless self.class.unscoped.where(authentication_token: token).first
    end
  end
end
