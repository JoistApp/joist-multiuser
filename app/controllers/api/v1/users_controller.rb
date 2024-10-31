# frozen_string_literal: true

module Api
  module V1
    class UsersController < ApiController
      before_action :set_target_user, only: %i[update destroy]

      def tabs
        render json: {tabs: Service::FetchUserTabs.new(user).call}
      end

      def index
        company_users = User.where(company_id: company_id)
        users = ActiveModel::Serializer::CollectionSerializer.new(company_users, serializer: Api::UserSerializer, user_id:).as_json
        render json: {data: {users: users, links: LinkHelper.get_links(user, "user")}}
      end

      def update
        if user.role.users_enabled && target_user_id.present? && @target_user.company_id == company_id.to_i
          if @target_user.update(**user_params)
            render json: {invoice: Api::UserSerializer.new(@target_user, user_id:)}
          else
            render json: @target_user.errors, status: :unprocessable_entity
          end
        else
          render json: {error: "Permission to update a user denied"}, status: :forbidden
        end
      end

      def destroy
        render json: {error: "Permission to delete a user denied"}, status: :forbidden if @target_user.role.is_primary || !user.role.users_enabled

        @target_user.destroy
      end

      private

      def set_target_user
        @target_user ||= User.find(target_user_id)
      end

      def target_user_id
        params.require(:id)
      end

      def user_params
        params.require(:user).permit(:email, :first_name, :last_name, :phone, :role_id)
      end
    end
  end
end