class SalesController < ApplicationController
    
    def index
        @product = Product.find_by(handle: params[:product_handle])
        @columnNames = self.getColumnNames()
        @inventoryByVariant = self.getInventoryByVariantForMonth
    end

    def getColumnNames
        today = Time.now.getutc.to_date
        columns = []
        for i in 1..today.mday
            date = today.beginning_of_month.advance(:days => (i - 1))
            columns.append(date.strftime("%d/%m/%Y"))
        end

      return columns
    end

    def getInventoryForMonth
        inventoryByDay = []
        today = Time.now.getutc.to_date
        for i in 1..today.mday
            day = getInventoryByDay(today.beginning_of_month.advance(:days => i - 1))

            inventory = 0
            # Calculate total inventory of all variants sold
            day.each do |item|
                inventory += item["inventory"].to_i
            end

            inventoryByDay.append(inventory)
        end

        return inventoryByDay
    end

    def getInventoryByVariantForMonth
        today = Time.now.getutc.to_date
        variants = Hash.new
        for i in 1..today.mday
            day = getInventoryByDay(today.beginning_of_month.advance(:days => i - 1))

            day.each do |item|
                if variants[item["title"]] == nil
                    variants[item["title"]] = []
                end

                variants[item["title"]].append(item["inventory"])
            end
        end
      return variants
    end
    
    def getSalesByHandle
        inventoryByDay = []
        today = Time.now.getutc.to_date
        for i in 1..today.mday
            day = getInventoryByDay(today.beginning_of_month.advance(:days => i - 1))

            inventory = 0
            prices = []

            hash = Hash.new

            # Calculate total inventory of all variants sold
            day.each do |item|
                inventory += item["inventory"].to_i
                prices.append(item["price"].to_f)
            end
            hash["totalInventory"] = inventory
            hash["lowestPrice"] = prices.min
            hash["variants"] = day

            inventoryByDay.append(hash)
        end
        
        return inventoryByDay
    end
    
    def getInventoryByDay(date)
        variants = @product.variants.where(:created_at => date.beginning_of_day.utc..date.end_of_day.utc, :product_id => @product.id)
        
        data = []
        variants.each do |variant|
            data.append(
                {
                    "title" => variant.title,
                    "inventory" => variant.inventory,
                    "price" => variant.price,
                    "date" => variant.created_at
                }
            )
        end
        
        return data
    end
    
    def allowed_params
     params.require(:product_handle)
    end
end
