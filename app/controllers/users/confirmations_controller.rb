# frozen_string_literal: true

class Users::ConfirmationsController < Devise::ConfirmationsController
  def show
    super do |resource|
      next unless resource.errors.empty?

      TrackEventJob.perform_later("email_verified", {}, resource.id)
    end
  end

  def confirmed
    render(template: "devise/confirmations/confirmed")
  end

  def confirmation_resent
    render(template: "devise/confirmations/confirmation_resent")
  end

  protected

  # The path used after resending confirmation instructions.
  def after_resending_confirmation_instructions_path_for(_resource_name)
    user_confirmation_resent_path
    # user_confirmed_path
    # is_navigational_format? ? new_session_path(resource_name) : '/'
  end

  # The path used after confirmation.
  def after_confirmation_path_for(_resource_name, _resource)
    user_confirmed_path
    # if signed_in?(resource_name)
    #   signed_in_root_path(resource)
    # else
    #  new_session_path(resource_name)
    # end
  end
end
