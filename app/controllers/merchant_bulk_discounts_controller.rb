class MerchantBulkDiscountsController < ApplicationController

  def index
    @merchant = Merchant.find(params[:merchant_id])
    @discounts = @merchant.bulk_discounts    
  end

  def show
    @merchant = Merchant.find(params[:merchant_id])
    @discount = BulkDiscount.find(params[:id])
  end

  def new
    @merchant = Merchant.find(params[:merchant_id])
    @discount = @merchant.bulk_discounts.new
  end

  def create
    @merchant = Merchant.find(params[:merchant_id])
    @discount = @merchant.bulk_discounts.new(discount_params)
    if @discount.save
      redirect_to merchant_bulk_discounts_path(@merchant)
    else
      flash[:notice] = @discount.errors.full_messages.to_sentence
      redirect_to "/merchants/#{@merchant.id}/bulk_discounts/new"
    end
  end

  def destroy
    @merchant = (Merchant.find(params[:merchant_id]))
    discount = BulkDiscount.find(params[:id])
    discount.destroy
    redirect_to merchant_bulk_discounts_path(@merchant)
  end

  def edit 
    @merchant = Merchant.find(params[:merchant_id])
    @discount = BulkDiscount.find(params[:id])
  end

  def update
    @merchant = Merchant.find(params[:merchant_id])
    @discount = BulkDiscount.find(params[:id])
    if @discount.update(discount_params)
      redirect_to merchant_bulk_discount_path(@merchant, @discount)
    else 
      flash[:notice] = @discount.errors.full_messages.to_sentence
      redirect_to "/merchants/#{@merchant.id}/bulk_discounts/#{@discount.id}/edit"
    end
  end

  private

  def discount_params
    params.require(:bulk_discount).permit(:name, :quantity_threshold, :percentage_discount)
  end
end