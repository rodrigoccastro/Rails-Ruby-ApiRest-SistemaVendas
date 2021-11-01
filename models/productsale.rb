class Productsale < ApplicationRecord
  validates :value, presence: true
  validates :quantity,  presence: true
  belongs_to :sale
  belongs_to :product
end
