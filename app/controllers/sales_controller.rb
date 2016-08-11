class SalesController < ApplicationController
    
    def index
      @product = Product.find_by(handle: params[:product_handle])
      @columnNames = self.getColumnNames()
      @inventoryByVariant = self.getInventoryByVariantForMonth()

      # today = Time.now.getutc.to_date
      # puts "Inventory Date Range:"
      # puts today.beginning_of_month.advance(:days => today.mday - 1).beginning_of_day
      # puts "to"
      # puts puts today.beginning_of_month.advance(:days => today.mday - 1).end_of_day
    end

    def getColumnNames
        today = Time.zone.now.to_date
        columns = []
        for i in 1..today.mday
            day = today.beginning_of_month.advance(:days => (i - 1))
            columns.append(day.strftime("%d/%m/%Y"))
        end

      return columns
    end

    def getInventoryForMonth
        inventoryByDay = []
        today = Time.zone.now.to_date
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
      today = Time.zone.now.to_date
      variants = Hash.new

        for i in 1..today.mday
            day = getInventoryByDay(today.beginning_of_month.advance(:days => i - 1))

            if day.length > 0
                day.each do |item|
                    if variants[item["title"]] == nil
                        variants[item["title"]] = []
                    end
                end
            end
        end

        for i in 1..today.mday
            day = getInventoryByDay(today.beginning_of_month.advance(:days => i - 1))
            puts day

            if day.length > 0
                day.each do |item|
                    if variants[item["title"]] == nil
                        variants[item["title"]] = []
                    end

                    variants[item["title"]].append(item["inventory"])
                end
            else
              variants.each do |key, value|
                  variants[key].append(0)
              end
            end
        end
      return variants
    end
    
    def getInventoryByHandle
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
        variants = @product.variants.where(:created_at => date.beginning_of_day..date.end_of_day, :product_id => @product.id)
        
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
