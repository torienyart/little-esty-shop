class Invoice < ApplicationRecord
  belongs_to :customer
  has_many :invoice_items
  has_many :items, through: :invoice_items
  has_many :transactions
  
  enum status: ["in progress", "completed", "cancelled"]

  def self.incomplete_invoices
    joins(:invoice_items).where({status: 0, "invoice_items.status": [0, 1]}).distinct.order(:created_at)
  end

  def total_revenue
    invoice_items.sum('unit_price * quantity')
  end

  def merchant_total_revenue(merchant_id)
    invoice_items.joins(item: :merchant).where('merchants.id = ?', merchant_id).sum('invoice_items.unit_price * invoice_items.quantity')
  end

  def discounted_revenue
    discounted = invoice_items.joins(item: [merchant: :bulk_discounts])
                      .select('invoice_items.*, MAX(bulk_discounts.percentage_discount) AS max_discount, ((invoice_items.unit_price * invoice_items.quantity) * MAX(bulk_discounts.percentage_discount)) AS rev')
                      .where('invoice_items.quantity >= bulk_discounts.quantity_threshold')
                      .group('invoice_items.id')
                    
    total = self.total_revenue - discounted.sum(&:rev)
  end

  def merchant_discounted_revenue(merchant_id)
    discounted = invoice_items.joins(item: [merchant: :bulk_discounts])
                      .select('invoice_items.*, MAX(bulk_discounts.percentage_discount) AS max_discount, ((invoice_items.unit_price * invoice_items.quantity) * MAX(bulk_discounts.percentage_discount)) AS rev')
                      .where('invoice_items.quantity >= bulk_discounts.quantity_threshold and merchants.id = ?', merchant_id)
                      .group('invoice_items.id')
                    
    total = self.merchant_total_revenue(merchant_id) - discounted.sum(&:rev)
  end
end