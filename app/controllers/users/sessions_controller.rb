# frozen_string_literal: true

class Users::SessionsController < Devise::SessionsController
  # include ApplicationHelper
  include ActionController::MimeResponds
  skip_before_action :require_no_authentication

  respond_to :json
  respond_to :html, only: []
  respond_to :xml, only: []

  # GET /resource/sign_in
  def new
    super
    respond_to do |format|
      format.html { redirect_to "https:://www.google.ca", allow_other_host: true, status: :moved_permanently }
      format.any { head 404, "content_type" => "text/plain" }
    end
  end

  # POST /resource/sign_in
  def create
    resource = warden.authenticate!(:password, scope: resource_name, store: false)
    sign_in(resource)
    respond_to do |format|
      format.json { render status: 200, json: {success: true, auth_token: resource.authentication_token}.merge(resource.as_json) }
    end
  end

  # DELETE /resource/sign_out
  def destroy
    super
  end

  protected

  # If you have extra params to permit, append them to the sanitizer.
  def configure_sign_in_params
    devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
  end
end
