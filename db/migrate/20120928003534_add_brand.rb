class AddBrand < ActiveRecord::Migration
  def up
    add_column :sale_items, :brand, :string
  end

  def down
    remove_column :sale_items, :brand
  end
end
