# frozen_string_literal: true

module Api
  class SettingsSerializer < BaseSerializer
    attributes :first_name, :last_name, :phone
    attributes :company_name, :company_address, :links

    def company_name
      object.company.name
    end

    def company_address
      [
        object.company.street, object.company.suite, object.company.city,
        object.company.zip, object.company.state, object.company.country
      ].compact.join(", ")
    end

    def links
      settings_links = []

      user = User.find(user_id)
      settings_links << {
        rel: "self",
        href: Rails.application.routes.url_helpers.company_settings_url(user_id:, company_id:, host: BASE_URL, protocol: "http"),
        method: "GET",
        title: "Get user settings",
      } if user.role.settings_visible
      settings_links << {
        rel: "update",
        href: Rails.application.routes.url_helpers.company_settings_url(user_id:, company_id:, host: BASE_URL, protocol: "http"),
        method: "PUT",
        title: "Update user settings",
      } if user.role.settings_enabled
      settings_links
    end

    def user_id
      @instance_options[:user_id]
    end

    def company_id
      @instance_options[:user_id]
    end
  end
end
