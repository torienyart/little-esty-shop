require 'rails_helper'

describe 'as a merchant when i visit my bulk discount show page' do
  before(:each) do
    @merchant = Merchant.create!(name: "Carlos Jenkins") 
    @bd1 = @merchant.bulk_discounts.create!(quantity_threshold: 10, percentage_discount: 0.1)
    visit merchant_bulk_discount_path(@merchant, @bd1)
  end

  it "I see the bulk discount's quantity threshold and percentage discount" do
    expect(page).to have_content(@bd1.quantity_threshold)
    expect(page).to have_content(@bd1.percentage_discount * 100)
  end

  describe 'bulk discount edit' do
    it 'I see a link to edit the bulk discount' do
      expect(page).to have_button("Edit")
    end

    it 'When I click this link I am taken to a new page with a form to edit the discount' do
      click_button("Edit")

      expect(page).to have_current_path(edit_merchant_bulk_discount_path(@merchant, @bd1))
    end

    it "When I click submit, I am redirected to the bulk discount's show page, and I see that the discount's attributes have been updated" do
      click_button "Edit"
      fill_in "bulk_discount[quantity_threshold]", with: '20'
      fill_in "bulk_discount[percentage_discount]", with: '.20'
      click_button "Update Bulk Discount"
  
      expect(page).to have_current_path(merchant_bulk_discount_path(@merchant, @bd1))
      expect(page).to have_content('Quantity Threshold: 20')
      expect(page).to have_content('Discount Percentage: 20.0%')
    end
  
  end
end