class ItemsController < ApplicationController
  def index
    @merchant = Merchant.find(params[:merchant_id])
    @top_items = @merchant.top_five_items_by_revenue
  end

	def show
		@merchant = Merchant.find(params[:merchant_id])
		@item = @merchant.items.find(params[:id])
	end
  
  def new
    @merchant = Merchant.find(params[:merchant_id])
  end

	def edit
		@merchant = Merchant.find(params[:merchant_id])
		@item = @merchant.items.find(params[:id])
	end

  def create
		@merchant = Merchant.find(params[:merchant_id])
    @item = @merchant.items.new(item_params)
    
    if @item.save
      redirect_to "/merchants/#{@merchant.id}/items"
    else
      flash[:notice] = "Item not created: Required information missing"
      redirect_to "/merchants/#{@merchant.id}/items/new"
    end
  end

	def update
    @merchant = Merchant.find(params[:merchant_id])
    @item = @merchant.items.find(params[:id])
		if params[:status] == "disabled"
      @item.update(status: 1)
      redirect_to merchant_items_path(@merchant)
    elsif params[:status] == "enabled"
      @item.update(status: 0)
      redirect_to merchant_items_path(@merchant)
		elsif @item.update(item_params)
			flash[:success] = "Item updated successfully"
    	redirect_to merchant_item_path(@merchant, @item)
		else
			flash[:fail] = "Item unable to be updated"
    	redirect_to edit_merchant_item_path(@merchant, @item)
  	end
	end
  

  private

  def item_params
    # params.require(:item).permit(:name, :description, :unit_price, :merchant_id)
    params.permit(:name, :description, :unit_price, :merchant_id)
  end
end