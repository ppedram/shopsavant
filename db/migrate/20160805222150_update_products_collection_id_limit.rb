class UpdateProductsCollectionIdLimit < ActiveRecord::Migration
  def change
    change_column :products, :collection_id, :integer, :limit => 12
  end
end
