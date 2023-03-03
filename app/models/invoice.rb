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

  # def merchant_invoice_items(params)
  #   require 'pry'; binding.pry
  #   invoice_items.where(invoice_id:params)
  # end
end