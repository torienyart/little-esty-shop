require 'rails_helper'

describe 'as a merchant when i click edit bulk discount, I am taken to a new page with a form to edit the discount' do
  before(:each) do
    @merchant = Merchant.create!(name: "Carlos Jenkins") 
    @bd1 = @merchant.bulk_discounts.create!(quantity_threshold: 10, percentage_discount: 0.1)
    visit edit_merchant_bulk_discount_path(@merchant, @bd1)
  end

  it 'had a form w/ fields' do
    expect(page).to have_field('bulk_discount[quantity_threshold]')
    expect(page).to have_field('bulk_discount[percentage_discount]')
    expect(page).to have_button('Update Bulk Discount')
  end

  it 'I see that the discounts current attributes are pre-poluated in the form' do
    expect(page).to have_field('bulk_discount[quantity_threshold]', with: '10')
    expect(page).to have_field('bulk_discount[percentage_discount]', with: '0.1')

  end

  it "I change any/all of the information and click submit, I am redirected to the bulk discount's show page" do
    fill_in "bulk_discount[quantity_threshold]", with: '20'
    fill_in "bulk_discount[percentage_discount]", with: '.20'
    click_button "Update Bulk Discount"

    expect(page).to have_current_path(merchant_bulk_discount_path(@merchant, @bd1))
  end

  it "can provide an error message!" do
    fill_in "bulk_discount[quantity_threshold]", with: 'twenty'
    fill_in "bulk_discount[percentage_discount]", with: '20'
    click_button "Update Bulk Discount"

    expect(page).to have_content("Quantity threshold is not a number and Percentage discount must be less than 1")
  end
end