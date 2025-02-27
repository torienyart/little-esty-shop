require 'rails_helper'

describe 'As a user when i visit my bulk discount index page' do
  before(:each) do
    @merchant = Merchant.create!(name: "Carlos Jenkins") 
    @merchant_2 = Merchant.create!(name: "Lil Pump")
    @bd1 = @merchant.bulk_discounts.create!(quantity_threshold: 10, percentage_discount: 0.1)
    @bd2 = @merchant.bulk_discounts.create!(quantity_threshold: 15, percentage_discount: 0.20)
    @bd3 = @merchant.bulk_discounts.create!(quantity_threshold: 20, percentage_discount: 0.25)
    @bd4 = @merchant_2.bulk_discounts.create!(quantity_threshold: 50, percentage_discount: 0.50)

    visit merchant_bulk_discounts_path(@merchant)
  end

  it 'I see all of my bulk discounts including their percentage and quantity threshold' do
    
    expect(page).to have_no_content(@bd4.id)

    within "#bd-#{@bd1.id}" do
      expect(page).to have_content(@bd1.id)
      expect(page).to have_content(@bd1.quantity_threshold)
      expect(page).to have_content(@bd1.percentage_discount*100)
    end

    within "#bd-#{@bd2.id}" do
      expect(page).to have_content(@bd2.id)
      expect(page).to have_content(@bd2.quantity_threshold)
      expect(page).to have_content(@bd2.percentage_discount*100)
    end

    within "#bd-#{@bd3.id}" do
      expect(page).to have_content(@bd3.id)
      expect(page).to have_content(@bd3.quantity_threshold)
      expect(page).to have_content(@bd3.percentage_discount*100)
    end
  end

  it 'And each bulk discount listed includes a link to its show page' do
    expect(page).to have_link("Bulk Discount #{@bd1.id}", href: merchant_bulk_discount_path(@merchant, @bd1))
    expect(page).to have_link("Bulk Discount #{@bd2.id}", href: merchant_bulk_discount_path(@merchant, @bd2))
    expect(page).to have_link("Bulk Discount #{@bd3.id}", href: merchant_bulk_discount_path(@merchant, @bd3))
  end

  describe 'i can create a new bulk discount' do
    it 'I see a link to create a new discount' do
      expect(page).to have_link("Create Bulk Discount", href: new_merchant_bulk_discount_path(@merchant))
    end

    it 'When I click this link, I am taken to a new page where I see a form to add a new bulk discount' do
      click_link "Create Bulk Discount"

      expect(page).to have_current_path(new_merchant_bulk_discount_path(@merchant))
    end

    it 'when i correctly fill out the form and click submit, I am taken to the index page where I see the new bulk discount' do
      click_link "Create Bulk Discount"
      fill_in 'bulk_discount[quantity_threshold]', :with => '30'
      fill_in 'bulk_discount[percentage_discount]', :with => '.30'
      click_button 'Create Bulk Discount'

      expect(page).to have_current_path(merchant_bulk_discounts_path(@merchant))
      expect(page).to have_content("Bulk Discount #{@bd1.id + 1}")
      expect(page).to have_content("Quantity Threshold: 30")
      expect(page).to have_content("Discount Percentage: 30")
    end
  
  end

  describe 'i can delete a bulk discount' do
    it 'next to each bulk discount I see a link to delete it' do
      expect(page).to have_button("Delete Bulk Discount", count: 3)
    end

    it 'When I click this link I am redirected back to the bulk discounts index page and I no longer see the discount listed' do
      within "#bd-#{@bd1.id}" do
        click_button "Delete Bulk Discount"
      end
      
      expect(page).to have_current_path(merchant_bulk_discounts_path(@merchant))
      expect(page).to have_no_content("Bulk Discount #{@bd1.id}")
      expect(page).to have_button("Delete Bulk Discount", count: 2)
    end
  end

  describe 'I see a section with a header of "Upcoming Holidays"' do
    it 'There is a section with a header of "Upcoming Holidays"' do
      within '#upcoming_holidays' do
        expect(page).to have_content('Upcoming Holidays')
      end
    end

    it 'In this section the name and date of the next 3 upcoming US holidays are listed.' do
      within '#upcoming_holidays' do
        expect(page).to have_content('Good Friday')
        expect(page).to have_content('Memorial Day')
        expect(page).to have_content('Juneteenth')
      end
    end
  end
end