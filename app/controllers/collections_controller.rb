class CollectionsController < ApplicationController
  def index
    @collections = Collection.includes(:products).where.not( :products => { :id => nil })
  end

  def scan
    url = "http://www.bellamihair.com/collections.json"
    uri = URI(url)
    response = Net::HTTP.get(uri)
    json = JSON.parse(response)
    collections = json["collections"]
    
    collections.each do |item|
      collection = Collection.find_or_initialize_by(collection_id: item["id"])
      collection.handle = item["handle"]
      collection.title = item["title"]
      collection.products_count = item["products_count"]
      collection.save
    end
  end
end
