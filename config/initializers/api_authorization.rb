# frozen_string_literal: true

class ApiAuthorization
  class Token
    def self.valid?(token)
      !(token =~ /^((([a-z]+:)?\d+:)?)([a-zA-z0-9\-_]{20})$/).nil?
    end

    def self.find_user!(token)
      raise ActiveRecord::RecordNotFound if token.blank?

      if ApiAuthorization::Token.id_prefix_token?(token)
        user_id = self.user_id(token)
        return User.find(user_id)
      end

      User.find_by!(authentication_token: token)
    end

    def self.id_prefix_token?(token)
      id, auth_token = token.split(":", 2)
      id.present? && auth_token.present? && !id.match(/^\d+$/).nil?
    end

    def self.user_id(token)
      token.split(":", 2).first.to_i
    end
  end

  class Header
    def self.key
      "X-Api-Authorization"
    end

    def self.instance(user)
      {key => "#{header_prefix} #{user.authentication_token}"}
    end

    def self.valid?(header)
      token_prefix, token = header.split(" ")
      (token_prefix == header_prefix) && ApiAuthorization::Token.valid?(token)
    end

    def self.token(header)
      header.split(" ")[1] if header && valid?(header)
    end

    def self.header_prefix
      "Joist-Token"
    end
  end
end
