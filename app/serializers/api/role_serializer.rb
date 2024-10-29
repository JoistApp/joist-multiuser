# frozen_string_literal: true

module Api
  class RoleSerializer < BaseSerializer
    attributes :name, :description, :is_primary
    attributes :roles_visible, :roles_enabled, :users_visible, :users_enabled
    attributes :estimates_enabled, :invoices_enabled, :settings_visible, :settings_enabled
    attributes :links

    def links
      role_links = []
      return role_links if object.is_primary?

      user = User.find(user_id)
      role_links << {
        rel: "edit",
        href: Rails.application.routes.url_helpers.company_role_url(user_id:, company_id:, id: object.id, host: BASE_URL, protocol: "http"),
        method: "PUT",
        title: "Update role",
      } if user.role.roles_enabled
      role_links << {
        rel: "delete",
        href: Rails.application.routes.url_helpers.company_role_url(user_id:, company_id:, id: object.id, host: BASE_URL, protocol: "http"),
        method: "DELETE",
        title: "Delete role",
      } if user.role.roles_enabled
      role_links
    end

    def user_id
      @instance_options[:user_id]
    end

    def company_id
      @instance_options[:user_id]
    end
  end
end