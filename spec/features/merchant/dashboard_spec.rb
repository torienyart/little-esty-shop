RSpec.describe 'Merchant Dashboard' do
	before(:each) do
		@merchant = Merchant.create!(name: "Carlos Jenkins") 
		visit "/merchants/#{@merchant.id}/dashboard"
	end

  describe 'As a user when I visit my merchant dashboard' do
    it 'I see the name of my merchant' do 

      expect(page).to have_content("Welcome to your dashboard, Carlos Jenkins")
    end

    it 'see link to my merchant items index and merchant invoices index' do 

      expect(page).to have_link("My Merchant Items Index", href: "/merchants/#{@merchant.id}")
      expect(page).to have_link("My Merchant Invoices Index", href: "/merchants/#{@merchant.id}/invoices")
    end
	end
end