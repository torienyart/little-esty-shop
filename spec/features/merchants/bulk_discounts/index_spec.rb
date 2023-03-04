require 'rails_helper'

RSpec.describe 'Merchant Bulk Discount Index' do
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
    @summer = @merchant.bulk_discounts.create!(percentage_discount: 0.10, quantity_threshold: 5, name: "Summer Sale")

    @merchant2 = Merchant.create!(name: "Someother Jenkins")
    @winter = @merchant2.bulk_discounts.create!(percentage_discount: 0.5, quantity_threshold: 2, name: "Winter Sale")

    visit "/merchants/#{@merchant.id}/bulk_discounts"
	end
  
  describe 'As a merchant when I visit my bulk discount dashboard' do
    it 'displays all of the merchants bulk discouts and their details' do
      within "#discounts" do
        expect(page).to have_content("Bulk Discounts:")
        expect(page).to have_content("BOGO Percent Discount: 0.5 Quantity Threshold: 100")
        expect(page).to have_content('Holiday Sale Percent Discount: 0.2 Quantity Threshold: 10')
        expect(page).to have_content('Summer Sale Percent Discount: 0.1 Quantity Threshold: 5')
        expect(page).to_not have_content('Winter Sale Percent Discount: 0.5 Quantity Threshold: 2')
      end
    end
    it 'each discount has a link to its show page' do
      within "#discounts" do
        expect(page).to have_link(@bogo.name)
        expect(page).to have_link(@holiday.name)
        expect(page).to have_link(@summer.name)

        click_link @bogo.name
        expect(current_path).to eq("/merchants/#{@merchant.id}/bulk_discounts/#{@bogo.id}")
      end
    end

    it 'has a link to create a new discount' do
      expect(page).to have_link("Create New Discount")
      click_link "Create New Discount"
      expect(current_path).to eq("/merchants/#{@merchant.id}/bulk_discounts/new")
    end

    it 'has a link to delete each discount' do
      expect(page).to have_content @bogo.name
      expect(page).to have_button "Delete BOGO"
      click_button "Delete BOGO"

      expect(current_path).to eq "/merchants/#{@merchant.id}/bulk_discounts"

      expect(page).to_not have_content @bogo.name
    end
	end
end