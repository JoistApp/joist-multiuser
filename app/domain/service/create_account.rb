# frozen_string_literal: true

module Service
  class CreateAccount < Service::Base
    def initialize(user)
      @user = user
    end

    def call
      attach_company if @user.company.blank?
      create!

      @user
    end

    private

    def create!
      User.transaction do
        @user.role_id = Role.where(is_primary: true).first.id if @user.role_id.blank?
        @user.save!
      end
    end

    def attach_company
      @user.build_company(email: @user.email, name: Faker::Company.name)
      @user.company.country = "US"
    end
  end
end
