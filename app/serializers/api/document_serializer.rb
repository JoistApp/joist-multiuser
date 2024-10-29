# frozen_string_literal: true

module Api
  class DocumentSerializer < BaseSerializer
    attributes :id, :name, :email, :phone, :user_id, :company_id
    attributes :created_by, :company_name

    def created_by
      "#{object.user.first_name} #{object.user.last_name}".strip
    end

    def company_name
      object.company.name
    end

    def user_id
      @instance_options[:user_id]
    end

    def company_id
      @instance_options[:user_id]
    end
  end
end
