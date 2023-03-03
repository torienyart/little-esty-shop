require 'rails_helper'

RSpec.describe 'Merchant Bulk Discount Show' do
	before(:each) do
		Merchant.destroy_all
		Customer.destroy_all
		Invoice.destroy_all
		Item.destroy_all
		Transaction.destroy_all
		InvoiceItem.destroy_all
		@merchant = Merchant.create!(name: "Carlos Jenkins") 
		
    
    @bogo = @merchant.bulk_discounts.create!(percentage_discount: 50, quantity_threshold: 100, name: "BOGO")
    @holiday = @merchant.bulk_discounts.create!(percentage_discount: 20, quantity_threshold: 10, name: "Holiday Sale")

    visit "/merchants/#{@merchant.id}/bulk_discounts/#{@bogo.id}"
	end

  describe 'As a merchant when I visit a bulk discount show page' do
    it 'displays the bulk discount and its details' do
      expect(page).to have_content("Bulk Discount: #{@bogo.name}")
      expect(page).to have_content("Percent Discount: 50%")
      expect(page).to have_content("Quantity Threshold: 100")
      expect(page).to_not have_content @holiday.name
    end

    it 'has a link to edit the discount' do
      expect(page).to have_button "Edit Discount"
      expect(page).to have_content("Bulk Discount: #{@bogo.name}")
      expect(page).to have_content("Percent Discount: 50%")
      expect(page).to have_content("Quantity Threshold: 100")
      click_button "Edit Discount"


      expect(current_path).to eq "/merchants/#{@merchant.id}/bulk_discounts/#{@bogo.id}/edit"
    end
  end 
end
