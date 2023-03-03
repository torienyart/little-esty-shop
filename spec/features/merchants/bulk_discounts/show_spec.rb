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
  
  end
end