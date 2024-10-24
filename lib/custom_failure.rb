# frozen_string_literal: true

class CustomFailure < Devise::FailureApp
  # You need to override respond to eliminate recall
  def respond
    if request.format.present? && request.format.json?
      self.content_type = "application/json"
      self.status = 401
      self.response_body = {success: false, errors: [i18n_message(:invalid_token)]}.to_json
    else
      super
    end

    # if http_auth?
    #   http_auth
    # else
    #   redirect
    # end
  end
end
