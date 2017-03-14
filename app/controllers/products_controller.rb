require "json"

class ProductsController < ApplicationController
  def index
    collection = Collection.find_by(:handle => params[:collection])
    if params[:order_by] == "sales"
      @products = Product.includes(:variants).where.not(:variants => { :id => nil }).paginate(:page => params[:page], :per_page => 100).order(total_sales: :desc)
    elsif params[:order_by] == "inventory"
        @products = Product.includes(:variants).where.not(:variants => { :id => nil }).paginate(:page => params[:page], :per_page => 100).order(total_inventory: :desc)
    else
      @products = Product.includes(:variants).where.not(:variants => { :id => nil }).paginate(:page => params[:page], :per_page => 100).order(product_updated_at: :desc)
    end
  end

  def scan
    Product.scan(params[:collection])
  end
  
  def allowed_params
    params.require(:collection)
  end
  
    def index
    @products = Product.all
    respond_to do |format|
      format.html
      format.csv { send_data @products.to_csv(['name', 'category', 'price']) }
    end
  end

  def import
    Product.import(params[:file])
    redirect_to root_url, notice: "Products imported."
  end

end
