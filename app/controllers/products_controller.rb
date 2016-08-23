require "json"

class ProductsController < ApplicationController
  def index
    collection = Collection.find_by(:handle => params[:collection])
    if params[:order_by] == "sales"
      @products = Product.includes(:variants).where.not(:variants => { :id => nil }).order(total_sales: :desc).limit(100)
    elsif params[:order_by] == "inventory"
        @products = Product.includes(:variants).where.not(:variants => { :id => nil }).order(total_inventory: :desc).limit(100)
    else
      @products = Product.includes(:variants).where.not(:variants => { :id => nil }).order(product_updated_at: :desc).limit(100)
    end
  end

  def scan
    Product.scan(params[:collection])
  end
  
  def allowed_params
    params.require(:collection)
  end
end
