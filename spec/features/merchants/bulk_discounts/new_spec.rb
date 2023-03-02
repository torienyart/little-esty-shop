require 'rails_helper'

describe 'as a visitor when I click the link to create a new bulk_discount' do
  before :each do
    @merchant = Merchant.create!(name: "Carlos Jenkins") 
    visit new_bulk_discount_path(@merchant)
  end

  describe 'I see a form to add a new bulk discount' do
    it 'has the correct fields' do
      expect(page).to have_field(quantity_threshold)
      expect(page).to have_field(percentage_discount)
      expect(page).to have_button('Create Bulk Discount')
    end

    it 'I am redirected back to the bulk discount index when i fill in the form with valid data' do
      fill_in 'quantity_threshold', :with => '10'
      fill_in 'percentage_discount', :with => '.15'
      click_button 'Create Bulk Discount'

      expect(page).to have_current_path(bulk_discounts_path)

    end

    it 'displays a failure message when there is a validation error' do
      fill_in 'quantity_threshold', :with => '10'
      fill_in 'percentage_discount', :with => '15'
      click_button 'Create Bulk Discount'

      expect(page).to have_content('Quantity threshold must be greater than 0')
    end

    it 'displays a failure message when there is a validation error' do
      fill_in 'quantity_threshold', :with => '10'
      click_button 'Create Bulk Discount'

      expect(page).to have_content('Please enter a valid value for the percentage discount')
    end
  end
end