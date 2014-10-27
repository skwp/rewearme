class AddSourceSite < ActiveRecord::Migration
  def up
    add_column :sale_items, :source_site, :string
  end

  def down
    remove_column :sale_items, :source_site
  end
end
