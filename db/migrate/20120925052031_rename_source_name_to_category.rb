class RenameSourceNameToCategory < ActiveRecord::Migration
  def up
    rename_column :sale_items, :source_name, :category rescue nil
  end

  def down
  end
end
