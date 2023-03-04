class MerchantInvoicesController < ApplicationController

  def index
    @merchant = Merchant.find(params[:id])
    @invoices = @merchant.invoices_with_items

  end

  def show
		@invoice = Invoice.find(params[:id])
		@merchant = Merchant.find(params[:merchant_id])
	end

end
