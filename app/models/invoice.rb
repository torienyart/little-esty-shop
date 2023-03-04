class Invoice < ApplicationRecord
  belongs_to :customer
  has_many :invoice_items
  has_many :items, through: :invoice_items
  has_many :transactions
  has_many :merchants, through: :items
  # has_many :bulk_discounts, through: :items
  
  enum status: ["in progress", "completed", "cancelled"]

  def self.incomplete_invoices
    joins(:invoice_items).where({status: 0, "invoice_items.status": [0, 1]}).distinct.order(:created_at)
  end

  def total_discount
    invoice_items.joins(:bulk_discounts)
    .where('invoice_items.quantity >= bulk_discounts.quantity_threshold')
    .select('invoice_items.*, max(bulk_discounts.percentage_discount * invoice_items.quantity * invoice_items.unit_price) as discount_rev')
    .group(:id)
    .sum(&:discount_rev)
  end

  def discounted_items
    x = invoice_items.joins(:bulk_discounts)
    .where('invoice_items.quantity >= bulk_discounts.quantity_threshold')
    .select('invoice_items.*, max(bulk_discounts.percentage_discount * invoice_items.quantity * invoice_items.unit_price) as discount_rev')
    .group(:id)
  end
end