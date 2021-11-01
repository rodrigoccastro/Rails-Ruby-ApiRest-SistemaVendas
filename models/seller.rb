class Seller < ApplicationRecord
    validates :number, presence: true
    validates :name,  presence: true
    has_many :sales
end
