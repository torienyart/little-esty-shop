require 'rails_helper'

describe 'as a visitor when I click the link to create a new bulk_discount' do
  before :each do
    @merchant = Merchant.create!(name: "Carlos Jenkins") 
    visit new_merchant_bulk_discount_path(@merchant)
  end

  describe 'I see a form to add a new bulk discount' do
    it 'has the correct fields' do
      expect(page).to have_field('bulk_discount[quantity_threshold]')
      expect(page).to have_field('bulk_discount[percentage_discount]')
      expect(page).to have_button('Create Bulk Discount')
    end

    it 'I am redirected back to the bulk discount index when i fill in the form with valid data' do
      fill_in 'bulk_discount[quantity_threshold]', :with => '10'
      fill_in 'bulk_discount[percentage_discount]', :with => '.15'
      click_button 'Create Bulk Discount'

      expect(page).to have_current_path(merchant_bulk_discounts_path(@merchant))

    end

    it 'displays a failure message when there is a validation error' do
      fill_in 'bulk_discount[quantity_threshold]', :with => 'f'
      fill_in 'bulk_discount[percentage_discount]', :with => '15'
      click_button 'Create Bulk Discount'

      expect(page).to have_content('Quantity threshold is not a number')
    end

    it 'displays a failure message when there is a validation error' do
      fill_in 'bulk_discount[quantity_threshold]', :with => '10'
      click_button 'Create Bulk Discount'

      expect(page).to have_content("Percentage discount can't be blank and Percentage discount is not a number")
    end

    it 'displays a failure message when there is a validation error' do
      fill_in 'bulk_discount[quantity_threshold]', :with => '10'
      fill_in 'bulk_discount[percentage_discount]', :with => '0'

      click_button 'Create Bulk Discount'

      expect(page).to have_content("Percentage discount must be greater than 0")
    end
  end
end