# frozen_string_literal: true

module Api
  module V1
    class InvoicesController < ApiController
      def index
        company_invoices = Invoice.where(company_id: company_id)
        invoices = ActiveModel::Serializer::CollectionSerializer.new(company_invoices, serializer: Api::InvoiceSerializer, user_id:).as_json
        render json: {data: {invoices: invoices,
                             links: LinkHelper.get_links(user, "invoice")}}
      end

      def create
        if user.role.invoices_enabled
          invoice = Invoice.new(user_id: user_id, company_id: company_id, **invoice_params)
          if invoice.save
            render json: {invoice: Api::InvoiceSerializer.new(invoice, user_id:)}, status: :created
          else
            render json: invoice.errors, status: :unprocessable_entity
          end
        else
          render json: {error: "Permission to create an invoice denied"}, status: :forbidden
        end
      end

      def update
        if user.role.invoices_enabled
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



      def destroy
        if user.role.invoices_enabled
          invoice = Invoice.find(invoice_id)
          if invoice.destroy
            render json: {message: "Invoice deleted"}
          else
            render json: invoice.errors, status: :unprocessable_entity
          end
        else
          render json: {error: "Permission to delete an invoice denied"}, status: :forbidden
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