class BulkDiscountsController < ApplicationController
  def index
    @merchant = Merchant.find(params[:merchant_id])
    @bulk_discounts = BulkDiscount.all
  end

  def new
    @merchant = Merchant.find(params[:merchant_id])
  end

  def create
    @merchant = Merchant.find(params[:merchant_id])
    bulk_discount = @merchant.bulk_discounts.new(quantity_threshold: params[:bulk_discount][:quantity_threshold], percentage_discount: params[:bulk_discount][:percentage_discount])
    if bulk_discount.save
      redirect_to merchant_bulk_discounts_path(@merchant), notice: "Successfully created bulk discount."
    else
      flash[:notice] = bulk_discount.errors.full_messages.to_sentence
      render :new
    end
  end
end