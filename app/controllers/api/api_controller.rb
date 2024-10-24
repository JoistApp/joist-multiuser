# frozen_string_literal: true

class Api::ApiController < Api::AuthenticatedController
  FIXNUM_MAX = (2**(0.size * 8 - 2) - 1)

  def initialize
    super
    # version = self.class.to_s.scan(/V\d+/).first
    # self.class.send(:include, "ApiVersion::#{version}".constantize)
  end

  def api_version
    1
  end

  def api_client_data
    @api_client_data ||= ::Infrastructure::ApiClient::Data.make(current_user)
  end

  def api_client_headers
    ::Infrastructure::ApiClient::Headers.make(
      request_user_agent: request.user_agent
    )
  end

  protected

  def page_params
    params.permit(:page)
  end

  def page
    page_params[:page] ? page_params[:page].to_i : 0
  end

  def per_page
    # This is more objects than I would expect a user to have before!
    page_params[:page] ? 10 : FIXNUM_MAX
  end

  # TODO: remove this when pagination is implemented in joist-web-client
  def fetch_all
    # This allows the joist web client ember app to fetch all records to avoid pagination
    params.permit(:fetch_all)[:fetch_all]
  end

  def user_id
    params.require(:user_id)
  end

  def company_id
    params.require(:company_id)
  end
end
