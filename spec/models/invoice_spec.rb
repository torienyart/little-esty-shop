require 'rails_helper'

RSpec.describe Invoice, type: :model do
  
  describe "relationships" do
    it { should belong_to :customer }
    it { should have_many :transactions }
    it { should have_many(:items).through(:invoice_items) }
    it { should have_many :invoice_items }
    it { should have_many(:merchants).through(:items) }

  end

  describe 'instance methods' do
    before :each do
      @merchant = Merchant.create!(name: "Carlos Jenkins") 
      @bowl = @merchant.items.create!(name: "bowl", description: "it's a bowl", unit_price: 350) 
      @knife = @merchant.items.create!(name: "knife", description: "it's a knife", unit_price: 250) 
      @cust1 = Customer.create!(first_name: "Laura", last_name: "Fiel")
      @cust2 = Customer.create!(first_name: "Bob", last_name: "Fiel")
      @cust3 = Customer.create!(first_name: "John", last_name: "Fiel")
      @cust4 = Customer.create!(first_name: "Tim", last_name: "Fiel")
      @cust5 = Customer.create!(first_name: "Linda", last_name: "Fiel")
      @cust6 = Customer.create!(first_name: "Lucy", last_name: "Fiel")
      @inv1 = @cust1.invoices.create!(status: 1)
      @inv2 = @cust2.invoices.create!(status: 1)
      @inv3 = @cust3.invoices.create!(status: 1)
      @inv4 = @cust4.invoices.create!(status: 1)
      @inv5 = @cust6.invoices.create!(status: 1)
      @inv6 = @cust5.invoices.create!(status: 0)
      @inv8 = @cust6.invoices.create!(status: 0)
      @inv9 = @cust6.invoices.create!(status: 0)
      @inv7 = @cust4.invoices.create!(status: 0)
      InvoiceItem.create!(item_id: @bowl.id, invoice_id: @inv1.id, status: 2)
      InvoiceItem.create!(item_id: @bowl.id, invoice_id: @inv2.id, status: 2)
      InvoiceItem.create!(item_id: @bowl.id, invoice_id: @inv3.id, status: 2)
      InvoiceItem.create!(item_id: @knife.id, invoice_id: @inv4.id, status: 2)
      InvoiceItem.create!(item_id: @bowl.id, invoice_id: @inv5.id, status: 2)
      InvoiceItem.create!(item_id: @bowl.id, invoice_id: @inv6.id, status: 0)
      InvoiceItem.create!(item_id: @bowl.id, invoice_id: @inv7.id, status: 0)
      InvoiceItem.create!(item_id: @bowl.id, invoice_id: @inv8.id, status: 1)
      InvoiceItem.create!(item_id: @bowl.id, invoice_id: @inv9.id, status: 1)
      InvoiceItem.create!(item_id: @bowl.id, invoice_id: @inv9.id, status: 2)  
    end

    it 'can determine incomplete invoice' do
      expect(Invoice.incomplete_invoices).to eq([@inv6 , @inv8, @inv9, @inv7])
    end
  end

  describe 'calculating bulk discounts' do
    before :each do
      Merchant.destroy_all
      Item.destroy_all
      InvoiceItem.destroy_all
      Customer.destroy_all

      @merchant1 = Merchant.create!(name: "Carlos Jenkins") 
      @merchant2 = Merchant.create!(name: "Leroy Jenkins")
      @cust1 = FactoryBot.create(:customer)
      @bowl = @merchant1.items.create!(name: "bowl", description: "it's a bowl", unit_price: 650) 
      @knife = @merchant1.items.create!(name: "knife", description: "it's a knife", unit_price: 450) 
      @plate = @merchant1.items.create!(name: "plate", description: "it's a plate", unit_price: 650) 
      @shirt = @merchant2.items.create!(name: "shirt", description: "it's a shirt", unit_price: 450) 
      @inv1 = @cust1.invoices.create!(status: 1)
    end

    it 'can calculate revenue where no discounts apply ' do
      @bd_a = @merchant1.bulk_discounts.create!(quantity_threshold: 10, percentage_discount: 0.20)
      @invit1 = InvoiceItem.create!(item_id: @bowl.id, invoice_id: @inv1.id, status: 2, quantity: 5 , unit_price: 600)
      @invit2 = InvoiceItem.create!(item_id: @knife.id, invoice_id: @inv1.id, status: 2, quantity: 5 , unit_price: 400)
      
      expect(@inv1.total_discount).to eq(0)
    end

    it 'can calculate revenue where discounts apply to just one invoice_item' do
      @bd_a = @merchant1.bulk_discounts.create!(quantity_threshold: 10, percentage_discount: 0.20)
      @invit1 = InvoiceItem.create!(item_id: @bowl.id, invoice_id: @inv1.id, status: 2, quantity: 10 , unit_price: 600)
      @invit2 = InvoiceItem.create!(item_id: @knife.id, invoice_id: @inv1.id, status: 2, quantity: 5 , unit_price: 400)

      expect(@inv1.total_discount).to eq(1200)
    end

    it 'can calculate revenue where two discounts apply' do
      @bd_a = @merchant1.bulk_discounts.create!(quantity_threshold: 10, percentage_discount: 0.20)
      @bd_b = @merchant1.bulk_discounts.create!(quantity_threshold: 15, percentage_discount: 0.30)

      @invit1 = InvoiceItem.create!(item_id: @bowl.id, invoice_id: @inv1.id, status: 2, quantity: 12 , unit_price: 600)
      @invit2 = InvoiceItem.create!(item_id: @knife.id, invoice_id: @inv1.id, status: 2, quantity: 15 , unit_price: 400)

      expect(@inv1.total_discount).to eq(1440 + 1800)
    end

    it 'can calculate revenue where two discounts apply but one is trumped' do
      @bd_a = @merchant1.bulk_discounts.create!(quantity_threshold: 10, percentage_discount: 0.20)
      @bd_b = @merchant1.bulk_discounts.create!(quantity_threshold: 15, percentage_discount: 0.15)

      @invit1 = InvoiceItem.create!(item_id: @bowl.id, invoice_id: @inv1.id, status: 2, quantity: 12 , unit_price: 600)
      @invit2 = InvoiceItem.create!(item_id: @knife.id, invoice_id: @inv1.id, status: 2, quantity: 15 , unit_price: 400)

      expect(@inv1.total_discount).to eq(1440 + 1200)
    end

    it 'can calculate revenue where two discounts apply and a third item is invalid' do
      @bd = @merchant1.bulk_discounts.create!(quantity_threshold: 5, percentage_discount: 0.10)
      @bd_b = @merchant1.bulk_discounts.create!(quantity_threshold: 15, percentage_discount: 0.30)

      @invit1 = InvoiceItem.create!(item_id: @bowl.id, invoice_id: @inv1.id, status: 2, quantity: 12 , unit_price: 600)
      @invit2 = InvoiceItem.create!(item_id: @knife.id, invoice_id: @inv1.id, status: 2, quantity: 15 , unit_price: 400)
      @invit2 = InvoiceItem.create!(item_id: @shirt.id, invoice_id: @inv1.id, status: 2, quantity: 16 , unit_price: 500)

      expect(@inv1.total_discount).to eq(720 + 1800)
    end
  end
end
