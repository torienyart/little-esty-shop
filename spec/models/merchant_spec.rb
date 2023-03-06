require 'rails_helper'

RSpec.describe Merchant, type: :model do
	
  describe "relationships" do
    it { should have_many :items }
    it { should have_many(:invoice_items).through(:items) }
    it { should have_many(:invoices).through(:invoice_items) }
    it { should have_many(:customers).through(:invoices) }
		it { should have_many(:transactions).through(:invoices) }
		it { should have_many(:bulk_discounts) }
    it { should validate_presence_of :name }
	
  end

  describe 'Instance Methods' do
		before do
			@merchant = Merchant.create(name: "Handmades")
			@merchant2 = Merchant.create(name: "No One Cares")
	
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
			@inv7 = @cust2.invoices.create!(status: 1, created_at: z)
	
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
			@bed = @merchant2.items.create!(name: "bed", description: "it's a bed", unit_price: 2500)
			
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

		it "can return invoice items for a merchants invoice by merchant" do
			Merchant.destroy_all
			Item.destroy_all
			InvoiceItem.destroy_all
			@merchant = Merchant.create(name: "Handmades")
			@merchant2 = Merchant.create(name: "No One Cares")
			@bowl = @merchant.items.create!(name: "bowl", description: "it's a bowl", unit_price: 350) 
			@knife = @merchant.items.create!(name: "knife", description: "it's a knife", unit_price: 300) 
			@spoon = @merchant.items.create!(name: "spoon", description: "it's a spoon", unit_price: 275) 
			@bed = @merchant2.items.create!(name: "bed", description: "it's a bed", unit_price: 2500)
			@invit1 = InvoiceItem.create!(item_id: @bowl.id, invoice_id: @inv1.id, quantity: 10, unit_price: 350, status: 1)
			@invit2 = InvoiceItem.create!(item_id: @knife.id, invoice_id: @inv1.id, quantity: 9, unit_price: 300, status: 1)
			@invit3 = InvoiceItem.create!(item_id: @spoon.id, invoice_id: @inv1.id, quantity: 10, unit_price: 200, status: 1)
			@invit4 = InvoiceItem.create!(item_id: @bed.id, invoice_id: @inv1.id, quantity: 8, unit_price: 2500, status: 1)
	
			expect(@merchant.merchant_invoice_items(@inv1.id)).to include(@invit1, @invit2, @invit3)
		end
		
		describe '#invoices_with_items' do
			it 'returns a list of distinct invoices' do
				expect(@merchant.invoices_with_items).to contain_exactly(@inv1, @inv2, @inv3, @inv4, @inv5, @inv6)
				expect(@merchant.invoices_with_items).to_not include(@inv7)
			end
		end

		describe '#top_five_items_by_revenue' do
			it 'top 5 most popular items ranked by total revenue generated' do
				expect(@merchant.top_five_items_by_revenue).to eq([@spoon, @bowl, @knife, @plate, @pan])
			end

			it 'date with the most revenue generated' do
				expect(@merchant.best_day.created_at).to eq(@inv1.created_at)
			end
		end

		describe "#top_five_merchants_by_revenue" do
			it 'returns the 5 merchants with the most revenue' do
				Merchant.destroy_all
				Item.destroy_all
				InvoiceItem.destroy_all
				Customer.destroy_all
				load_test_data
				expect(Merchant.top_five_merchants_by_revenue).to eq [@merchant3, @merchant5, @merchant6, @merchant1, @merchant4]
			end
		end
	end
end

