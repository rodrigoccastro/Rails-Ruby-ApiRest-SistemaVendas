class Product < ApplicationRecord
    validates :name,  presence: true
    validates :description,  presence: true
    validates :value,  presence: true
    has_many :productsales
end
