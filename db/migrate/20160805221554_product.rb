class Product < ActiveRecord::Migration
  def change
    change_column :products, :product_id, :integer, :limit => 12
  end
end
