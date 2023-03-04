class InvoiceItem < ApplicationRecord
  belongs_to :invoice
  belongs_to :item
  has_many :bulk_discounts, through: :item

  enum status: ['pending', 'packaged', 'shipped']

  def self.unshipped_items
    where(status: 'pending').or(where(status: 'packaged')).order(:created_at)
  end

  def self.total_revenue
    sum('invoice_items.unit_price * invoice_items.quantity')
  end

  def self.total_revenue_discount
    
  end
end
