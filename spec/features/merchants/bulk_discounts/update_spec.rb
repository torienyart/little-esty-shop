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
		
    
    @bogo = @merchant.bulk_discounts.create!(percentage_discount: 0.50, quantity_threshold: 100, name: "BOGO")
    @holiday = @merchant.bulk_discounts.create!(percentage_discount: 0.20, quantity_threshold: 10, name: "Holiday Sale")

    visit "/merchants/#{@merchant.id}/bulk_discounts/#{@bogo.id}/edit"
	end

  describe 'As a merchant when I visit a bulk discount edit page' do

    it 'the fields are pre-populated with the current info and I can change them to update the discount' do

      fill_in "Name", with: "Buy one hundred and one, get a sweet deal"
      fill_in "Quantity threshold", with: 101
      click_button "Update Bulk discount"
      
      expect(current_path).to eq "/merchants/#{@merchant.id}/bulk_discounts/#{@bogo.id}"
      expect(page).to have_content("Bulk Discount: Buy one hundred and one, get a sweet deal")
      expect(page).to have_content("Percent Discount: 0.5")
      expect(page).to have_content("Quantity Threshold: 101")
    end

    it 'displays a flash message if the discount is not updated' do
      fill_in "Name", with: ""
      fill_in "Percentage discount", with: ''
      fill_in "Quantity threshold", with: ''
      click_button "Update Bulk discount"

      expect(page).to have_content("Name can't be blank")
      expect(page).to have_content("Percentage discount can't be blank")
      expect(page).to have_content("Quantity threshold can't be blank")
      expect(page).to have_content("Percentage discount is not a number")
      expect(page).to have_content("Quantity threshold is not a number")
    end
  end 
end