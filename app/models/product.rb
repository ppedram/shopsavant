class Product < ActiveRecord::Base
    validates_uniqueness_of :product_id
    belongs_to :collection
    has_many :variants
end
