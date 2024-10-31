# frozen_string_literal: true

module Api
  module V1
    class EstimatesController < ApiController
      def index
        company_estimates = Estimate.where(company_id: company_id)
        estimates = ActiveModel::Serializer::CollectionSerializer.new(company_estimates, serializer: Api::EstimateSerializer, user_id:).as_json
        render json: {data: {estimates: estimates,
                             links: LinkHelper.get_links(user, "estimate")}}
      end

      def create
        if user.role.estimates_enabled
          estimate = Estimate.new(user_id: user_id, company_id: company_id, **estimate_params)
          if estimate.save
            render json: {estimate: Api::EstimateSerializer.new(estimate, user_id:)}, status: :created
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
            render json: {estimate: Api::EstimateSerializer.new(estimate, user_id:)}
          else
            render json: estimate.errors, status: :unprocessable_entity
          end
        else
          render json: {error: "Permission to update an estimate denied"}, status: :forbidden
        end
      end

      def destroy
        if user.role.estimates_enabled
          estimate = Estimate.find(estimate_id)
          if estimate.destroy
            render json: {message: "Estimate deleted"}
          else
            render json: estimate.errors, status: :unprocessable_entity
          end
        else
          render json: {error: "Permission to delete an estimate denied"}, status: :forbidden
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