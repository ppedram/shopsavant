class ChangeVariantPriceType < ActiveRecord::Migration
  def change
    change_column :variants, :price, :string, :limit => 10
  end
end
