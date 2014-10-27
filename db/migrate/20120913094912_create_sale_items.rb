class CreateSaleItems < ActiveRecord::Migration
  def change
    create_table :sale_items do |t|
      t.string :title
      t.text :description
      t.string :hires_thumbnail
      t.string :url
      t.string :username
      t.string :reputation
      t.string :price
      t.string :category
      t.text :images

      t.timestamps
    end
  end
end
