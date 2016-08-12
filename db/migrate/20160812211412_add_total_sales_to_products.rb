class AddTotalSalesToProducts < ActiveRecord::Migration
  def change
    add_column :products, :total_sales, :integer
  end
end
