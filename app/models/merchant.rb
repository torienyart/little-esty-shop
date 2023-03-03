class Merchant < ApplicationRecord
  has_many :items, dependent: :destroy
  has_many :invoice_items, through: :items
  has_many :invoices, through: :invoice_items
  has_many :customers, -> { distinct }, through: :invoices  
  has_many :transactions, -> { distinct }, through: :invoices
  has_many :bulk_discounts

  validates_presence_of :name, presence: true

  enum status: ["disabled", "enabled"]

  def invoices_with_items
	invoices.select(:id).distinct
  end
				
  def top_five_items_by_revenue
		Item.joins(invoice_items: [invoice: :transactions])
			.where('invoices.status = 1 AND transactions.result = 0')
			.group('items.id')
			.select('items.*, SUM(DISTINCT invoice_items.quantity * invoice_items.unit_price) as revenue')
			.order('revenue DESC')
			.limit(5)
  end

  def best_day
    invoices.where("invoices.status = 1")
    .select('invoices.created_at, sum(invoice_items.unit_price * invoice_items.quantity) as revenue')
    .group("invoices.created_at")
    .order("revenue desc", "invoices.created_at desc")
    .first  
  end

  def self.top_five_merchants_by_revenue
    joins(invoice_items: [invoice: :transactions])
    .where('transactions.result = 0')
    .select('merchants.*, SUM(DISTINCT invoice_items.quantity * invoice_items.unit_price) as revenue')
    .group('id')
    .order('revenue DESC')
    .limit(5)
  end

  def merchant_invoice_items(invoice_id)
    invoice_items.where(invoice_id:invoice_id)
  end
end
