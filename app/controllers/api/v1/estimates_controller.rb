# frozen_string_literal: true

module Api
  module V1
    class EstimatesController < ApiController
      def index
        company = current_user.company
        user_ids = company.users.pluck(:id)
        company_estimates = Estimate.where("user_id IN (?)", user_ids)
        render json: company_estimates, each_serializer: Api::EstimateSerializer
      end

      def create
        user = User.find(user_id)
        render status: :forbidden unless user.role.estimates_enabled

        estimate = Estimate.new(user_id: user_id, **estimate_params)
        if estimate.save
          render json: {estimate: Api::EstimateSerializer.new(estimate)}, status: :created
        else
          render json: estimate.errors, status: :unprocessable_entity
        end
      end

      private

      def estimate_id
        params.require(:id)
      end

      def estimate_params
        params.require(:estimate).permit(:name, :email, :phone)
      end
    end
  end
end