require "json"

class ProductsController < ApplicationController
  def index
    collection = Collection.find_by(:handle => params[:collection])
    @products = Product.includes(:variants).where( :collection => collection.id).where.not(:variants => { :id => nil }).order(created_at: :desc)
  end

  def scan
    Product.scan(params[:collection])
  end
  
  def allowed_params
    params.require(:collection)
  end
end
