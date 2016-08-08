class ChangeVariantInventoryType < ActiveRecord::Migration
  def change
    change_column :variants, :inventory, :string
  end
end
