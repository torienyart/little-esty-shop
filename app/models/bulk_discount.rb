class BulkDiscount < ApplicationRecord
  belongs_to :merchant
  has_many :items, through: :merchant
  has_many :invoice_items, through: :items

  validates :quantity_threshold, presence: true, numericality: { greater_than_or_equal_to: 0, only_integer: true }
  validates :percentage_discount, presence: true, numericality: { greater_than: 0, less_than: 1, only_float: true }
end