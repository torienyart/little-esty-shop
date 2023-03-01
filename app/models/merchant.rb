class Merchant < ApplicationRecord
  has_many :items, dependent: :destroy
  has_many :invoice_items, through: :items
  has_many :invoices, through: :invoice_items
  has_many :customers, -> { distinct }, through: :invoices  
  has_many :transactions, -> { distinct }, through: :invoices

  enum status: ["disabled", "enabled"]

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

  def unshipped_items
    # where(status: 'pending').or(where(status: 'packaged')).order(:created_at)
    # invoices.where()
    invoice_items.where(status: 'pending').or(where(status: 'packaged')).order(:created_at)
    # Invoice.joins(:invoice_items, :items)
    #        .select('invoice_items.*, invoices.created_at, items.merchant_id')
    #        .where({status: 0, "invoice_items.status": [0, 1], 'items.merchant_id': merchant_id})
    #        .distinct.order(:created_at)
  end

end
