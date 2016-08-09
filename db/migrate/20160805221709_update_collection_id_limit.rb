class UpdateCollectionIdLimit < ActiveRecord::Migration
  def change
    change_column :collections, :collection_id, :integer, :limit => 8
  end
end
