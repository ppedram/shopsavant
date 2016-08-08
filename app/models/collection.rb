require "json"

class Collection < ActiveRecord::Base
    validates_uniqueness_of :collection_id
    has_many :products
end
