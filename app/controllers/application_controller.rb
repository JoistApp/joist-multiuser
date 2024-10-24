# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include ErrorHandler

  protect_from_forgery

  before_action :set_context

  protected

  # Only to test the warden and current_user methods
  def set_context
    return unless warden.present? && current_user
  end
end
