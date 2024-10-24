# frozen_string_literal: true

module Api
  module V1
    class RolesController < ApiController
      before_action :set_role, only: %i[update destroy]

      def index
        global_roles = Role.where(company_id: nil)
        company_roles = Role.where(company_id: company_id)
        render json: {roles: global_roles + company_roles}
      end

      def create
        user = User.find(user_id)
        render status: :forbidden unless user.role.roles_enabled

        role = Role.new(company_id: company_id, is_primary: false, **role_params)
        if role.save
          render json: {role: role}, status: :created
        else
          render json: role.errors, status: :unprocessable_entity
        end
      end

      # PATCH/PUT /roles/1
      def update
        if @role.update(role_params)
          render json: @role
        else
          render json: @role.errors, status: :unprocessable_entity
        end
      end

      def destroy
        @role.destroy
      end

      private

      def set_role
        @role = Role.find(params[:id])
      end

      def role_params
        params.require(:role).permit(
          :name, :description,
          :roles_visible, :roles_enabled,
          :estimates_visible, :estimates_enabled,
          :invoice_visible, :invoice_enabled,
          :settings_visible, :settings_enabled)
      end
    end
  end
end