require 'rails_helper'

RSpec.describe '#' do
	before(:each) do
		Merchant.destroy_all
		Customer.destroy_all
		Invoice.destroy_all
		Item.destroy_all
		Transaction.destroy_all
		InvoiceItem.destroy_all
		@merchant = Merchant.create!(name: "Carlos Jenkins") 
		
    visit "/merchants/#{@merchant.id}/bulk_discounts/new"
	end
  
  describe 'As a merchant when I visit my bulk discount new page' do
    it 'has a form to create a new discount' do
      fill_in "Name", with: "New Discount"
      fill_in "Percentage discount", with: 0.25
      fill_in "Quantity threshold", with: 50
      click_button "Create Bulk discount"
      expect(current_path).to eq("/merchants/#{@merchant.id}/bulk_discounts")
      expect(page).to have_content("New Discount")
    end

    it 'displays a flash message if the discount is not created successfully' do
      fill_in "Name", with: ""
      fill_in "Percentage discount", with: ''
      fill_in "Quantity threshold", with: ''
      click_button "Create Bulk discount"

      expect(page).to have_content("Name can't be blank")
      expect(page).to have_content("Percentage discount can't be blank")
      expect(page).to have_content("Quantity threshold can't be blank")
      expect(page).to have_content("Percentage discount is not a number")
      expect(page).to have_content("Quantity threshold is not a number")
    end
	end
end
