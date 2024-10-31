# frozen_string_literal: true

module Service
  class FetchUserTabs < Service::Base
    def initialize(user)
      @user = user
      @tabs = []
    end

    def call
      role_links = LinkHelper.get_links(@user, "role")
      user_links = LinkHelper.get_links(@user, "user")
      estimate_links = LinkHelper.get_links(@user, "estimate")
      invoice_links = LinkHelper.get_links(@user, "invoice")
      settings_links = LinkHelper.get_links(@user, "settings")

      index = 0
      if role_links.any?
        @tabs << {
          id: 1,
          index: index,
          name: "Roles",
          description: "Manage user roles for company",
          links: role_links,
        }
        index = index.next
      end

      if user_links.any?
        get_roles_link = role_links.find { |l| l[:rel] == "self" }
        user_links << get_roles_link if get_roles_link
        @tabs << {
          id: 2,
          index: index,
          name: "Users",
          description: "Manage users for company",
          links: user_links,
        }
        index = index.next
      end

      if estimate_links.any?
        @tabs << {
          id: 3,
          index: index,
          name: "Estimates",
          description: "Manage estimates for company",
          links: estimate_links,
        }
        index = index.next
      end

      if invoice_links.any?
        @tabs << {
          id: 4,
          index: index,
          name: "Invoices",
          description: "Manage invoices for company",
          links: invoice_links,
        }
        index = index.next
      end

      if settings_links.any?
        @tabs << {
          id: 5,
          index: index,
          name: "Settings",
          description: "Manage user and company settings",
          links: settings_links,
        }
      end

      @tabs
    end
  end
end