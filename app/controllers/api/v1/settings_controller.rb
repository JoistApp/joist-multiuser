# frozen_string_literal: true

module Api
  module V1
    class SettingsController < ApiController
      def show
        render json: {settings: Api::SettingsSerializer.new(user, user_id:, company_id:)}
      end

      def update
        user.update(**user_settings_params) && user.company.update(**company_settings_params)
        render json:{settings: Api::SettingsSerializer.new(user)}
      end

      private

      def user_settings_params
        params.require(:settings).permit(:first_name, :last_name, :phone)
      end

      def company_settings_params
        params.require(:settings).permit(:company_name)
      end
    end
  end
end