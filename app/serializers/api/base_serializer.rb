# frozen_string_literal: true

module Api
  class BaseSerializer < ActiveModel::Serializer
    attributes :id, :created_at, :updated_at
  end
end
