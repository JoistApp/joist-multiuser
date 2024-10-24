# frozen_string_literal: true

module Service
  class CreateAccount < Service::Base
    def initialize(user)
      @user = user
      @link_list = []
    end

    def call
      if @user.role.is_primary
        add_estimate_links(is_editable: true)
      end
    end

    def add_estimate_links(is_editable: false)
      @links_list << {
        rel: "estimates",
        href: "",
        method: "GET",
        title: "Details"
      }
      if is_editable
        @link_list << "https://www.google.com"
      else
        @link_list << "https://www.bing.com"
      end
    end
  end
end