module LinkHelper
  extend self

  BASE_URL = 'https://localhost:4000'

  def get_links(user, model)
    case model
    when "estimate"
      get_estimate_links(user)
    when "invoice"
      get_invoice_links(user)
    when "user"
      get_user_links(user)
    when "role"
      get_role_links(user)
    when "settings"
      get_settings_links(user)
    end
  end

  private

  def get_estimate_links(user)
    link_list = []
    user_id = user.id
    company_id = user.company.id
    link_list << {
      rel: "self",
      href: Rails.application.routes.url_helpers.company_estimates_url(user_id:, company_id:, host: BASE_URL, protocol: "http"),
      method: "GET",
      title: "Get all estimates",
    }
    link_list << {
      rel: "add",
      href: Rails.application.routes.url_helpers.company_estimates_url(user_id:, company_id:, host: BASE_URL, protocol: "http"),
      method: "POST",
      title: "Add a new estimate",
    } if user.role.estimates_enabled
    link_list
  end


  def get_invoice_links(user)
    link_list = []
    user_id = user.id
    company_id = user.company.id
    link_list << {
      rel: "self",
      href: Rails.application.routes.url_helpers.company_invoices_url(user_id:, company_id:, host: BASE_URL, protocol: "http"),
      method: "GET",
      title: "Get all invoices",
    }
    link_list << {
      rel: "add",
      href: Rails.application.routes.url_helpers.company_invoices_url(user_id:, company_id:, host: BASE_URL, protocol: "http"),
      method: "POST",
      title: "Add a new invoice",
    } if user.role.invoices_enabled
    link_list
  end

  def get_role_links(user)
    link_list = []
    user_id = user.id
    company_id = user.company.id
    link_list << {
      rel: "self",
      href: Rails.application.routes.url_helpers.company_roles_url(user_id:, company_id:, host: BASE_URL, protocol: "http"),
      method: "GET",
      title: "Get all roles",
    } if user.role.roles_visible
    link_list << {
      rel: "add",
      href: Rails.application.routes.url_helpers.company_roles_url(user_id:, company_id:, host: BASE_URL, protocol: "http"),
      method: "POST",
      title: "Create a new role",
    } if user.role.roles_enabled
    link_list
  end

  def get_user_links(user)
    link_list = []
    user_id = user.id
    company_id = user.company.id
    link_list << {
      rel: "self",
      href: Rails.application.routes.url_helpers.company_users_url(user_id:, company_id:, host: BASE_URL, protocol: "http"),
      method: "GET",
      title: "Get all users",
    } if user.role.users_visible
    link_list << {
      rel: "add",
      href: Rails.application.routes.url_helpers.user_registration_url(host: BASE_URL, protocol: "http"),
      method: "POST",
      title: "Create a new user",
    } if user.role.users_enabled
    link_list
  end

  def get_settings_links(user)
    link_list = []
    user_id = user.id
    company_id = user.company.id
    link_list << {
      rel: "self",
      href: Rails.application.routes.url_helpers.company_settings_url(user_id:, company_id:, host: BASE_URL, protocol: "http"),
      method: "GET",
      title: "Get user settings",
    } if user.role.settings_visible
    link_list << {
      rel: "update",
      href: Rails.application.routes.url_helpers.company_settings_url(user_id:, company_id:, host: BASE_URL, protocol: "http"),
      method: "PUT",
      title: "Update user settings",
    } if user.role.settings_enabled
    link_list
  end
end
