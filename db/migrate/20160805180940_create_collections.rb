class CreateCollections < ActiveRecord::Migration
  def change
    create_table :collections do |t|
      t.integer :collection_id
      t.string :handle
      t.string :title
      t.integer :products_count

      t.timestamps null: false
    end
  end
end
