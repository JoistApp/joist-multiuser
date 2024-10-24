# frozen_string_literal: true

module Api
  class EstimateSerializer < BaseSerializer
    type "estimate"
    attributes :id, :name, :email, :phone, :user_id
    attributes :created_by

    def created_by
      "#{object.user.first_name} #{object.user.last_name}".strip
    end
  end
end
