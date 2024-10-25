# frozen_string_literal: true

module Api
  module V1
    class InvoicesController < ApiController
      def index
        company = user.company
        user_ids = company.users.pluck(:id)
        company_invoices = Invoice.where("user_id IN (?)", user_ids)
        render json: company_invoices, each_serializer: Api::InvoiceSerializer
      end

      def create
        if user.role.invoice_enabled
          invoice = Invoice.new(user_id: user_id, **invoice_params)
          if invoice.save
            render json: {invoice: Api::InvoiceSerializer.new(invoice)}, status: :created
          else
            render json: invoice.errors, status: :unprocessable_entity
          end
        else
          render json: {error: "Permission to create an invoice denied"}, status: :forbidden
        end
      end

      def update
        if user.role.invoice_enabled
          invoice = Invoice.find(invoice_id)
          if invoice.update(invoice_params)
            render json: {invoice: Api::InvoiceSerializer.new(invoice)}
          else
            render json: invoice.errors, status: :unprocessable_entity
          end
        else
          render json: {error: "Permission to update an invoice denied"}, status: :forbidden
        end
      end

      private

      def invoice_id
        params.require(:id)
      end

      def invoice_params
        params.require(:invoice).permit(:name, :email, :phone)
      end
    end
  end
end