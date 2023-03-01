require 'rails_helper'

RSpec.describe Merchant, type: :model do
	
  describe "relationships" do
    it { should have_many :items }
    it { should have_many(:invoice_items).through(:items) }
    it { should have_many(:invoices).through(:invoice_items) }
  end

  describe 'Instance Methods' do
    describe '#top_five_items_by_revenue' do
      before do
        @merchant = Merchant.create(name: "Handmades")


        @cust1 = FactoryBot.create(:customer)
        @cust2 = FactoryBot.create(:customer)
        w = Date.new(2019, 7, 18)
        x = Date.new(2020, 8, 17)
        y = Date.new(2020, 10, 9)
        z = Date.new(2016, 8, 3)


        @inv1 = @cust1.invoices.create!(status: 1, created_at: w)
        @inv2 = @cust1.invoices.create!(status: 1, created_at: w)
        @inv3 = @cust1.invoices.create!(status: 1, created_at: x)
        @inv4 = @cust2.invoices.create!(status: 1, created_at: y)
        @inv5 = @cust2.invoices.create!(status: 1, created_at: z)
        @inv6 = @cust2.invoices.create!(status: 1, created_at: z)

        @trans1 = @inv1.transactions.create!(credit_card_number: 5555555555555555, credit_card_expiration_date: nil, result: 0)
        @trans1_5 = @inv1.transactions.create!(credit_card_number: 5555555555555555, credit_card_expiration_date: nil, result: 0)
        @trans2 = @inv2.transactions.create!(credit_card_number: 5555555555555555, credit_card_expiration_date: nil, result: 0)
        @trans3 = @inv2.transactions.create!(credit_card_number: 5555555555555555, credit_card_expiration_date: nil, result: 0)
        @trans4 = @inv3.transactions.create!(credit_card_number: 5555555555555555, credit_card_expiration_date: nil, result: 0)
        @trans5 = @inv3.transactions.create!(credit_card_number: 5555555555555555, credit_card_expiration_date: nil, result: 0)
        @trans6 = @inv3.transactions.create!(credit_card_number: 5555555555555555, credit_card_expiration_date: nil, result: 0)
        @trans7 = @inv4.transactions.create!(credit_card_number: 5555555555555555, credit_card_expiration_date: nil, result: 0)
        @trans8 = @inv4.transactions.create!(credit_card_number: 5555555555555555, credit_card_expiration_date: nil, result: 0)
        @trans9 = @inv4.transactions.create!(credit_card_number: 5555555555555555, credit_card_expiration_date: nil, result: 0)
        @trans10 = @inv4.transactions.create!(credit_card_number: 5555555555555555, credit_card_expiration_date: nil, result: 0)
        @trans11 = @inv5.transactions.create!(credit_card_number: 5555555555555555, credit_card_expiration_date: nil, result: 0)
        @trans12 = @inv5.transactions.create!(credit_card_number: 5555555555555555, credit_card_expiration_date: nil, result: 0)
        @trans13 = @inv5.transactions.create!(credit_card_number: 5555555555555555, credit_card_expiration_date: nil, result: 0)
        @trans14 = @inv5.transactions.create!(credit_card_number: 5555555555555555, credit_card_expiration_date: nil, result: 0)
        @trans15 = @inv5.transactions.create!(credit_card_number: 5555555555555555, credit_card_expiration_date: nil, result: 0)
        @trans16 = @inv6.transactions.create!(credit_card_number: 5555555555555555, credit_card_expiration_date: nil, result: 0)

        @bowl = @merchant.items.create!(name: "bowl", description: "it's a bowl", unit_price: 350) 
        @knife = @merchant.items.create!(name: "knife", description: "it's a knife", unit_price: 300) 
        @spoon = @merchant.items.create!(name: "spoon", description: "it's a spoon", unit_price: 275) 
        @plate = @merchant.items.create!(name: "plate", description: "it's a plate", unit_price: 250) 
        @fork = @merchant.items.create!(name: "fork", description: "it's a fork", unit_price: 100) 
        @pan = @merchant.items.create!(name: "pan", description: "it's a pan", unit_price: 250) 
          
        InvoiceItem.create!(item_id: @bowl.id, invoice_id: @inv1.id, quantity: 10, unit_price: 350, status: 1)
        InvoiceItem.create!(item_id: @knife.id, invoice_id: @inv1.id, quantity: 9, unit_price: 300, status: 1)
        InvoiceItem.create!(item_id: @plate.id, invoice_id: @inv1.id, quantity: 10, unit_price: 200, status: 1)
        InvoiceItem.create!(item_id: @spoon.id, invoice_id: @inv1.id, quantity: 8, unit_price: 2500, status: 1)
        InvoiceItem.create!(item_id: @fork.id, invoice_id: @inv5.id, quantity: 1, unit_price: 14, status: 1)
        InvoiceItem.create!(item_id: @pan.id, invoice_id: @inv6.id, quantity: 6, unit_price: 15, status: 1)
        InvoiceItem.create!(item_id: @pan.id, invoice_id: @inv2.id, quantity: 6, unit_price: 15, status: 1)
        InvoiceItem.create!(item_id: @pan.id, invoice_id: @inv3.id, quantity: 6, unit_price: 15, status: 1)
        InvoiceItem.create!(item_id: @pan.id, invoice_id: @inv4.id, quantity: 6, unit_price: 15, status: 1)



      end

      it 'top 5 most popular items ranked by total revenue generated' do
        expect(@merchant.top_five_items_by_revenue).to eq([@spoon, @bowl, @knife, @plate, @pan])
      end

      it 'date with the most revenue generated' do
        expect(@merchant.best_day.created_at).to eq(@inv1.created_at)
      end
    end

    describe "#top_five_merchants_by_revenue" do
      it 'returns the 5 merchants with the most revenue' do
        load_test_data
        expect(Merchant.top_five_merchants_by_revenue).to eq [@merchant3, @merchant5, @merchant6, @merchant1, @merchant4]
        
      end
    end

    describe 'instance methods' do
      before :each do
        @merchant = Merchant.create!(name: "Carlos Jenkins") 
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
        @inv6 = @cust5.invoices.create!(status: 1)
        
        
        @bowl = @merchant.items.create!(name: "bowl", description: "it's a bowl", unit_price: 350) 
        @knife = @merchant.items.create!(name: "knife", description: "it's a knife", unit_price: 250) 
        @trans1 = @inv1.transactions.create!(credit_card_number: 5555555555555555, credit_card_expiration_date: nil, result: 0)
        @trans1_5 = @inv1.transactions.create!(credit_card_number: 5555555555555555, credit_card_expiration_date: nil, result: 0)
        @trans2 = @inv2.transactions.create!(credit_card_number: 5555555555555555, credit_card_expiration_date: nil, result: 0)
        @trans3 = @inv2.transactions.create!(credit_card_number: 5555555555555555, credit_card_expiration_date: nil, result: 0)
        @trans4 = @inv3.transactions.create!(credit_card_number: 5555555555555555, credit_card_expiration_date: nil, result: 0)
        @trans5 = @inv3.transactions.create!(credit_card_number: 5555555555555555, credit_card_expiration_date: nil, result: 0)
        @trans6 = @inv3.transactions.create!(credit_card_number: 5555555555555555, credit_card_expiration_date: nil, result: 0)
        @trans7 = @inv4.transactions.create!(credit_card_number: 5555555555555555, credit_card_expiration_date: nil, result: 0)
        @trans8 = @inv4.transactions.create!(credit_card_number: 5555555555555555, credit_card_expiration_date: nil, result: 0)
        @trans9 = @inv4.transactions.create!(credit_card_number: 5555555555555555, credit_card_expiration_date: nil, result: 0)
        @trans10 = @inv4.transactions.create!(credit_card_number: 5555555555555555, credit_card_expiration_date: nil, result: 0)
        @trans11 = @inv5.transactions.create!(credit_card_number: 5555555555555555, credit_card_expiration_date: nil, result: 0)
        @trans12 = @inv5.transactions.create!(credit_card_number: 5555555555555555, credit_card_expiration_date: nil, result: 0)
        @trans13 = @inv5.transactions.create!(credit_card_number: 5555555555555555, credit_card_expiration_date: nil, result: 0)
        @trans14 = @inv5.transactions.create!(credit_card_number: 5555555555555555, credit_card_expiration_date: nil, result: 0)
        @trans15 = @inv5.transactions.create!(credit_card_number: 5555555555555555, credit_card_expiration_date: nil, result: 0)
        @trans16 = @inv6.transactions.create!(credit_card_number: 5555555555555555, credit_card_expiration_date: nil, result: 0)
        
        @invit1 = InvoiceItem.create!(item_id: @bowl.id, invoice_id: @inv1.id, status: 1)
        @invit2 =InvoiceItem.create!(item_id: @bowl.id, invoice_id: @inv2.id, status: 1)
        @invit4 =InvoiceItem.create!(item_id: @knife.id, invoice_id: @inv4.id, status: 0)
        @invit3 =InvoiceItem.create!(item_id: @bowl.id, invoice_id: @inv3.id, status: 1)
        @invit5 =InvoiceItem.create!(item_id: @bowl.id, invoice_id: @inv5.id, status: 0)
        @invit6 =InvoiceItem.create!(item_id: @bowl.id, invoice_id: @inv6.id, status: 2)
      end
  
      it '#unshipped_items' do
          expect(@merchant.unshipped_items).to eq([@invit1, @invit2, @invit4, @invit3, @invit5])
          expect(@merchant.unshipped_items).to_not eq([@invit1, @invit2, @invit3, @invit4, @invit5])
          expect(@merchant.unshipped_items).to_not include(@invit6)							
      end
    end
  end
end

