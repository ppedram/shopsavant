class AddInventoryToProduct < ActiveRecord::Migration
  def change
    add_column :products, :total_inventory, :integer
  end
end
