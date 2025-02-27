require 'rails_helper'

describe BulkDiscount do
  describe 'relationships' do
    it { should belong_to :merchant }
    it { should have_many(:items).through(:merchant) }
    it { should have_many(:invoice_items).through(:items) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of :quantity_threshold }
    it { is_expected.to validate_presence_of :percentage_discount }
    it { is_expected.to validate_numericality_of :quantity_threshold }
    it { is_expected.to validate_numericality_of :percentage_discount } 
  end
end