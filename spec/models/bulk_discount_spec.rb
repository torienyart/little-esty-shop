require 'rails_helper'

describe BulkDiscount do
  it { should belong_to :merchant }
  it { should have_many(:items).through(:merchant) }
  it { should have_many(:invoice_items).through(:items) }

end