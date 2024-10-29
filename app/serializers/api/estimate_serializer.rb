# frozen_string_literal: true

module Api
  class EstimateSerializer < DocumentSerializer
    type "estimate"
    attributes :id, :name, :email, :phone, :user_id
    attributes :created_by, :links

    def created_by
      "#{object.user.first_name} #{object.user.last_name}".strip
    end

    def links
      estimate_links = []
      user = User.find(user_id)

      if user.role.estimates_enabled
        estimate_links << [{
          rel: "edit",
          href: Rails.application.routes.url_helpers.company_estimate_url(user_id: user_id, company_id: company_id, id: object.id, host: BASE_URL, protocol: "http"),
          method: "PUT",
          title: "Update estimate",
        }, {
          rel: "delete",
          href: Rails.application.routes.url_helpers.company_estimate_url(user_id: user_id, company_id: company_id, id: object.id, host: BASE_URL, protocol: "http"),
          method: "DELETE",
          title: "Delete estimate",
        }]
      end

      estimate_links
    end
  end
end
