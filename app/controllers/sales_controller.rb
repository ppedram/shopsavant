class SalesController < ApplicationController
    
    def index
        @product = Product.find_by(handle: params[:product_handle])
        @data = self.getSalesByHandle()
    end
    
    def getSalesByHandle
        inventoryByDay = []
        for i in 1..Date.today.mday
            day = getInventoryByDay(Date.today.beginning_of_month.advance(:days => i - 1))
            inventoryByDay.append(day)
        end
        
        return inventoryByDay
    end
    
    def getInventoryByDay(date)
        variants = @product.variants.where(:created_at => date.beginning_of_day..date.end_of_day, :product_id => @product.id)
        
        data = []
        variants.each do |variant|
            data.append({ title: variant.title, inventory: variant.inventory, date: variant.created_at })
        end
        
        return data
    end
    
    def allowed_params
     params.require(:product_handle)
    end
end
