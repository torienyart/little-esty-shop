class InvoicesController < ApplicationController
  def index
    @merchant = Merchant.find(params[:merchant_id])
    @invoices = @merchant.invoices_with_items
  end

	def show
		@invoice = Invoice.find(params[:id])
		@merchant = Merchant.find(params[:merchant_id])
		@invoice_items = @merchant.merchant_invoice_items(params[:id])
	end

	def update
		@invoice = Invoice.find(params[:id])
		@merchant = Merchant.find(params[:merchant_id])
		@invoice_item = InvoiceItem.find(params[:invoice_item][:ii_id])
    @invoice_item.update(status: params[:invoice_item][:status])
    redirect_to merchant_invoice_path(@merchant, @invoice)
    flash[:notice] = "Item Status has been updated successfully"
	end

	private
	def invoice_params
		params.require(:invoice_item).permit(:id, :status)
	end
end