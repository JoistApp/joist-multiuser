# frozen_string_literal: true

module Api
  class SettingsSerializer < BaseSerializer
    attributes :first_name, :last_name, :phone
    attributes :company_name, :company_address

    def company_name
      object.company.name
    end

    def company_address
      [
        object.company.street, object.company.suite, object.company.city,
        object.company.zip, object.company.state, object.company.country
      ].compact.join(", ")
    end
  end
end
