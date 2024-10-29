# frozen_string_literal: true

module Api
  class AuthenticatedController < ApplicationController
    include LinkHelper

    respond_to :json
    before_action :authenticate, :reject_if_user_id_and_token_do_not_match

    # If you are using token authentication with APIs and using trackable.
    # Every request will be considered as a new sign in (since there is no session in APIs).
    # You can disable this...
    prepend_before_action :skip_trackable

    #
    # We want to avoid using the cookie session information for API calls
    # Note: This may no longer be necessary
    # We do not include Devise's database_authenticatable strategy for the user scope anymore
    #
    prepend_before_action :skip_session_cookie

    private

    def authenticate
      authenticate_user!
    end

    def skip_trackable
      request.env["warden"].request.env["devise.skip_trackable"] = "1"
    end

    def skip_session_cookie
      cookies.delete("_joist_site_session")
    end

    def reject_if_user_id_and_token_do_not_match
      return true if params[:user_id].blank?

      # raise "Token does not match for user_id" if current_user&.id.to_s != params[:user_id]
    end
  end
end
