class MerchantBulkDiscountsController < ApplicationController

  def index
    @merchant = Merchant.find(params[:id])
    @discounts = @merchant.bulk_discounts    
  end

  def show
    @discount = BulkDiscount.find(params[:id])
  end

end