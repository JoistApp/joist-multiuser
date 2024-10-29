# frozen_string_literal: true

module Api
  class InvoiceSerializer < DocumentSerializer
    type "invoice"
    attributes :links

    def links
      invoice_links = []
      user = User.find(user_id)

      if user.role.invoices_enabled
        invoice_links << {
          rel: "edit",
          href: Rails.application.routes.url_helpers.company_invoice_url(user_id: user_id, company_id: company_id, id: object.id, host: BASE_URL, protocol: "http"),
          method: "PUT",
          title: "Update invoice",
        }
        invoice_links << {
          rel: "delete",
          href: Rails.application.routes.url_helpers.company_invoice_url(user_id: user_id, company_id: company_id, id: object.id, host: BASE_URL, protocol: "http"),
          method: "DELETE",
          title: "Delete invoice",
        }
      end

      invoice_links
    end
  end
end
