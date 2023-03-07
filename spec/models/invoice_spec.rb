require 'rails_helper'

RSpec.describe Invoice, type: :model do

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
  
  describe "relationships" do
    it { should belong_to :customer }
    it { should have_many :transactions }
    it { should have_many :invoice_items }
    it { should have_many(:items).through(:invoice_items) }
  end

  describe 'instance methods' do
    it 'can determine incomplete invoice' do
      expect(Invoice.incomplete_invoices).to eq([@inv6 , @inv8, @inv9, @inv7])
    end

    it 'can calculate total revenue' do
      w = Date.new(2019, 7, 18)
      @merchant = Merchant.create!(name: "Carlos Jenkins") 
      @cust1 = Customer.create!(first_name: "Laura", last_name: "Fiel")
      @inv1 = @cust1.invoices.create!(status: 1, created_at: w)
      @bowl = @merchant.items.create!(name: "bowl", description: "it's a bowl", unit_price: 350) 
      @knife = @merchant.items.create!(name: "knife", description: "it's a knife", unit_price: 250) 

      @invit1 = InvoiceItem.create!(item_id: @bowl.id, invoice_id: @inv1.id, status: 2, quantity: 10 , unit_price: 2222)
      @invit2 = InvoiceItem.create!(item_id: @bowl.id, invoice_id: @inv1.id, status: 2, quantity: 1, unit_price: 6654)
      @invit3 = InvoiceItem.create!(item_id: @bowl.id, invoice_id: @inv1.id, status: 2, quantity: 4, unit_price: 8765)
      @invit4 = InvoiceItem.create!(item_id: @knife.id, invoice_id: @inv1.id, status: 2, quantity: 2, unit_price: 4567)
      @invit5 = InvoiceItem.create!(item_id: @knife.id, invoice_id: @inv1.id, status: 2, quantity: 6, unit_price: 2050)

      expect(@inv1.total_revenue).to eq(85368)
      
    end

    describe 'merchant specific revenue' do
      it 'can calculate total discounted revenue for a particular merchant' do
        @bulk_discount1 = @merchant.bulk_discounts.create!(name: "10% off 10 items", percentage_discount: 0.10, quantity_threshold: 10)
        ## Adds a second applicable discount to same invoice_item to test that only the highest discount is applied
        @bulk_discount2 = @merchant.bulk_discounts.create!(name: "9% off 5 items", percentage_discount: 0.09, quantity_threshold: 5)
        @bulk_discount2 = @merchant.bulk_discounts.create!(name: "5% off 4 items", percentage_discount: 0.05, quantity_threshold: 4)
        @invit1 = InvoiceItem.create!(item_id: @bowl.id, invoice_id: @inv1.id, status: 2, quantity: 10 , unit_price: 2222)
        @invit2 = InvoiceItem.create!(item_id: @bowl.id, invoice_id: @inv1.id, status: 2, quantity: 1, unit_price: 6654)
        @invit3 = InvoiceItem.create!(item_id: @bowl.id, invoice_id: @inv1.id, status: 2, quantity: 4, unit_price: 8765)
        
        expect(@inv1.merchant_discounted_revenue(@merchant)).to eq 59959
        
      end
      
      it 'will return the total even if no discounts are applied' do
        @invit1 = InvoiceItem.create!(item_id: @bowl.id, invoice_id: @inv1.id, status: 2, quantity: 10 , unit_price: 2222)
        @invit2 = InvoiceItem.create!(item_id: @bowl.id, invoice_id: @inv1.id, status: 2, quantity: 1, unit_price: 6654)
        @invit3 = InvoiceItem.create!(item_id: @bowl.id, invoice_id: @inv1.id, status: 2, quantity: 4, unit_price: 8765)

        expect(@inv1.merchant_discounted_revenue(@merchant)).to eq 63934
      end
    end

    it 'can calculate total discounted revenue for an invoice' do
      @merchant2 = Merchant.create!(name: "Merchant 2")
      @sofa = @merchant2.items.create!(name: "sofa", description: "it's a sofa", unit_price: 350)

      @bulk_discount1 = @merchant.bulk_discounts.create!(name: "10% off 10 items", percentage_discount: 0.10, quantity_threshold: 10)
      ## Adds a second applicable discount to same invoice_item to test that only the highest discount is applied
      @bulk_discount2 = @merchant.bulk_discounts.create!(name: "9% off 5 items", percentage_discount: 0.09, quantity_threshold: 5)
      @bulk_discount2 = @merchant.bulk_discounts.create!(name: "5% off 4 items", percentage_discount: 0.05, quantity_threshold: 4)
      @invit1 = InvoiceItem.create!(item_id: @bowl.id, invoice_id: @inv1.id, status: 2, quantity: 10 , unit_price: 2222)
      @invit2 = InvoiceItem.create!(item_id: @bowl.id, invoice_id: @inv1.id, status: 2, quantity: 1, unit_price: 6654)
      @invit3 = InvoiceItem.create!(item_id: @bowl.id, invoice_id: @inv1.id, status: 2, quantity: 4, unit_price: 8765)
      @invit4 = InvoiceItem.create!(item_id: @sofa.id, invoice_id: @inv1.id, status: 2, quantity: 7, unit_price: 5000)

      expect(@inv1.discounted_revenue).to eq 94959
    end
  end
end
