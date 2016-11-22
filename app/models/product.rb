require "json"

class Product < ActiveRecord::Base
    validates_uniqueness_of :product_id
    belongs_to :collection
    has_many :variants, :dependent => :destroy
    has_many :sales, :dependent => :destroy

    attr_accessor :title, :handle, :product_type, :vendor, :product_published_at, :product_updated_at, :total_sales, :total_inventory


    def self.scanAll
        self.scan
    end

    def self.scan(page = 1)
        # Shopify currently caps us at 250 products per page
        url = "http://www.jeffreestarcosmetics.com/products.json?limit=250&page=" + page.to_s
        uri = URI(url)
        response = Net::HTTP.get(uri)
        json = JSON.parse(response)

        @products = json["products"]

        @products.each_with_index do |item, index|
            product = Product.find_or_initialize_by(product_id: item["id"])
            # Basic product attributes
            product["title"] = item["title"]
            product["handle"] = item["handle"]
            product["product_type"] = item["product_type"]
            product["vendor"] = item["vendor"]
            product["product_published_at"] = item["published_at"]
            product["product_updated_at"] = item["updated_at"]

            total_previous_inventory = product["total_inventory"].to_i

            product.save

            # Load more detailed JSON to get inventory
            product_url = "http://www.jeffreestarcosmetics.com/products/#{product["handle"]}.json"
            product_uri = URI(product_url)
            product_response = Net::HTTP.get(product_uri)
            product_json = JSON.parse(product_response)

            # Compile inventory
            total_inventory = 0
            variants = product_json["product"]["variants"]
            variants.each do |item_v|
                product.variants.create(
                    title: item_v["title"],
                    price: item_v["price"],
                    inventory: item_v["inventory_quantity"],
                    sku: item_v["sku"]
                )
                inventory = item_v["inventory_quantity"].to_i
                if inventory > 0
                  total_inventory += inventory
                    # puts "Add Inventory: #{inventory}"
                end
            end

            # Calculate sales since yesterday, if yesterday's data exists and product hasn't been restocked
            if (total_previous_inventory >= total_inventory)
              sale = (total_previous_inventory - total_inventory).abs
            else
              sale = 0
            end

            product.sales.create(sales_count: sale)

            # Compile sales
            previous_sales = item["total_sales"].to_i
            total_sales = previous_sales + sale

            # Final save now that we have inventory and sales
            # puts "Total Inventory: #{total_inventory}"
            product["total_sales"] = total_sales
            product["total_inventory"] = total_inventory
            product.save

            puts "(#{index})Scanned: #{product["handle"]} - Total Sales: #{sale}/#{total_sales}"
            puts "------------"
        end

      # Scan next page until we hit 8 / 2000 products
      if page < 6
        self.scan(page + 1)
      end
    end
end
