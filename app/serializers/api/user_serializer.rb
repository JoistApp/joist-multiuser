# frozen_string_literal: true

module Api
  class UserSerializer < BaseSerializer
    attributes :email, :first_name, :last_name, :phone, :role_id, :company_id
    attributes :role, :company_name, :links

    def role
      object.role.name
    end

    def company_name
      object.company.name
    end

    def links
      user_links = []
      user = User.find(user_id)

      user_links << {
        rel: "edit",
        href: Rails.application.routes.url_helpers.company_user_url(user_id: ,company_id: object.company_id, id: object.id, host: BASE_URL, protocol: "http"),
        method: "PUT",
        title: "Update user",
      } if user.role.users_visible
      user_links << {
        rel: "delete",
        href: Rails.application.routes.url_helpers.company_user_url(user_id: , company_id: object.company_id, id: object.id, host: BASE_URL, protocol: "http"),
        method: "DELETE",
        title: "Delete user",
      } if user.role.users_enabled
      user_links
    end

    def user_id
      @instance_options[:user_id]
    end
  end
end