class UpdateProductsCollectionIdLimit < ActiveRecord::Migration
  def change
    change_column :products, :collection_id, :integer, :limit => 8
  end
end
