class AddPublishAndUpdatedDatesToProducts < ActiveRecord::Migration
  def change
    add_column :products, :product_published_at, :datetime
    add_column :products, :product_updated_at, :datetime
  end
end
