class BulkDiscountsController < ApplicationController
  def index
    @merchant = Merchant.find(params[:merchant_id])
    @bulk_discounts = @merchant.bulk_discounts
  end

  def new
    @merchant = Merchant.find(params[:merchant_id])
    @bulk_discount = BulkDiscount.new
  end

  def show
    @merchant = Merchant.find(params[:merchant_id])
    @bulk_discount = BulkDiscount.find(params[:id])
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

  def edit
    @merchant = Merchant.find(params[:merchant_id])
    @bulk_discount = BulkDiscount.find(params[:id])
  end

  def update
    @merchant = Merchant.find(params[:merchant_id])
    @bulk_discount = BulkDiscount.find(params[:id])
    if @bulk_discount.update(quantity_threshold: params[:bulk_discount][:quantity_threshold], percentage_discount: params[:bulk_discount][:percentage_discount])
      redirect_to merchant_bulk_discount_path(@merchant, @bulk_discount), notice: "Successfully updated bulk discount."
    else
      flash[:notice] = @bulk_discount.errors.full_messages.to_sentence
      render :edit
    end
  end
  def destroy
    @merchant = Merchant.find(params[:merchant_id])
    bulk_discount = BulkDiscount.find(params[:id])
    bulk_discount.destroy
    redirect_to merchant_bulk_discounts_path(@merchant), notice: "Successfully deleted bulk discount."
  end

  private

  bulk_discount_params = params.require(:bulk_discount).permit(:quantity_threshold, :percentage_discount)
end