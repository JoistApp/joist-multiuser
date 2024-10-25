# frozen_string_literal: true

module Api
  module V1
    class EstimatesController < ApiController
      def index
        company = user.company
        user_ids = company.users.pluck(:id)
        company_estimates = Estimate.where("user_id IN (?)", user_ids)
        render json: company_estimates, each_serializer: Api::EstimateSerializer
      end

      def create
        if user.role.estimates_enabled
          estimate = Estimate.new(user_id: user_id, **estimate_params)
          if estimate.save
            render json: {estimate: Api::EstimateSerializer.new(estimate)}, status: :created
          else
            render json: estimate.errors, status: :unprocessable_entity
          end
        else
          render json: {error: "Permission to create an estimate denied"}, status: :forbidden
        end
      end

      def update
        if user.role.estimates_enabled
          estimate = Estimate.find(estimate_id)
          if estimate.update(estimate_params)
            render json: {estimate: Api::EstimateSerializer.new(estimate)}
          else
            render json: estimate.errors, status: :unprocessable_entity
          end
        else
          render json: {error: "Permission to update an estimate denied"}, status: :forbidden
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