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
    # bulk_discounts.joins(:invoice_items)
    # .distinct.group('invoice_items.id')
    # .sum("invoice_items.quantity * 
    #   (invoice_items.unit_price - 
    #     (invoice_items.unit_price * bulk_discounts.order
    #       ('quantity_threshold DESC').where('bulk_discounts.quantity_threshold <= invoice_items.quantity').first.percentage_discount))")
    
    invoice_items.joins(:bulk_discounts)
    .where('invoice_items.quantity >= bulk_discounts.quantity_threshold')
    .select('invoice_items.*, max(bulk_discounts.percentage_discount * invoice_items.quantity * invoice_items.unit_price) as discount_rev')
    .group(:id)
    .sum(&:discount_rev)
    

   
    # .order('bulk_discounts.percentage_discount DESC')
    # x = bulk_discounts.joins(:invoice_items)
    # .where('invoice_items.quantity >= bulk_discounts.quantity_threshold')
    # .where(merchant_id: merchant_id)
    # .distinct
    # .order('bulk_discounts.percentage_discount DESC')
    # .group(:id)
    # .sum('invoice_items.quantity * invoice_items.unit_price * (1 - bulk_discounts.percentage_discount)') 

  
                #  .select('invoice_items.id, max(invoice_items.quantity * (invoice_items.unit_price - (invoice_items.unit_price * bulk_discounts.percentage_discount))) as total_discount')
                 

    # x = bulk_discounts.joins(:invoice_items)
    # .where('invoice_items.quantity >= bulk_discounts.quantity_threshold')
    # .where(merchant_id: merchant_id)
    # .select('invoice_items.id, invoice_items.unit_price, max(invoice_items.quantity) as quantity, invoice_items.unit_price * bulk_discounts.threshold as discount_amount')
    # .group('invoice_items.id')
    # .sum('(invoice_items.unit_price - discount_amount) * invoice_items.quantity')
  
    # .distinct
    # .order('bulk_discounts.percentage_discount DESC')
    # .group('bulk_discounts.percentage_discount')
    # .sum('invoice_items.quantity * invoice_items.unit_price * (1 - bulk_discounts.percentage_discount)') 
    
    # require 'pry'; binding.pry
  end

  def invoice_discounted_revenue
    bulk_discounts.joins(:invoice_items)
  end
end