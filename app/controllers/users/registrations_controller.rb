# frozen_string_literal: true

module Users
  class RegistrationsController < Devise::RegistrationsController
    # include ApplicationHelper
    skip_before_action :require_no_authentication

    respond_to :json
    respond_to :html, only: []
    respond_to :xml, only: []

    def create
      render status: 200, json: resource.as_json.merge(auth_token: resource.authentication_token)
    end

    protected

    def resource
      @resource ||= Service::CreateAccount.call(build_user)
    end

    def build_user
      build_resource(registration_params[:user])
    end

    def registration_params
      params.permit(
        device_identity: %i[platform vendor_id],
        user: user_params
      )
    end

    def user_params
      %i[email password password_confirmation company_id role_id first_name, last_name, phone]
    end
  end
end
