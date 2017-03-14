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

def generate_csv_data(template = nil)
  template ||= "#{controller_name}/#{action_name}.html.slim"
  content = render_to_string(template)
  doc =  Nokogiri::HTML(content)

  table =  doc.at_css('table')
  data = table.css('tr').map do |r|
    r.css('td,th').map(&:text).to_csv
  end.join

  # Convert from utf8 to gbk to make it compatible with Windows Office Excel
  # And Mac number can work with GBK too
  data = data.encode('GBK', undef: :replace, replace: "")
end

# Respond csv file when csv format requested
format.csv { send_data generate_csv_data }

  
end
