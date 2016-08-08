class CreateProducts < ActiveRecord::Migration
  def change
    create_table :products do |t|
      t.integer :product_id
      t.string :handle
      t.string :type
      t.string :vendor
      t.references :collection, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
