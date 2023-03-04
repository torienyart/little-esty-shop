class BulkDiscount < ApplicationRecord
  belongs_to :merchant
  

  validates_presence_of :percentage_discount, :quantity_threshold, :name
  validates_numericality_of :percentage_discount, { greater_than: 0, less_than: 1 }
  validates_numericality_of :quantity_threshold

  
end
