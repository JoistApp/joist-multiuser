# frozen_string_literal: true

class Users::PasswordsController < Devise::PasswordsController
  include Whitelist
  skip_before_action :require_no_authentication

  # POST /resource/password
  def create
    resource_class.send_reset_password_instructions(resource_params)
    render status: 201, json: {success: 1}
  end

  # PUT /resource/password
  def update
    self.resource = resource_class.reset_password_by_token(resource_params)

    if resource.errors.empty?
      resource.reset_authentication_token!
      sign_in(resource_name, resource)
      respond_with resource, location: after_resetting_password_path_for(resource)
    elsif resource.errors.messages[:reset_password_token].any?
      render(template: "devise/passwords/reset_token_expired") && return
    else
      respond_with resource
    end
  end

  def reset_token_expired
  end

  def reset_success
    # just render the reset page
  end

  protected

  def after_resetting_password_path_for(_resource)
    host = ActionMailer::Base.default_url_options[:host]
    protocol = ActionMailer::Base.default_url_options[:protocol]
    Rails.application.routes.url_helpers.reset_password_success_url(host: host, protocol: protocol)
  end
end
