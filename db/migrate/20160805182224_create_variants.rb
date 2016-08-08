class CreateVariants < ActiveRecord::Migration
  def change
    create_table :variants do |t|
      t.string :title
      t.integer :price
      t.integer :inventory
      t.string :sku
      t.references :product, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
