class SaleItemImage < ActiveRecord::Base
  attr_accessible :url

  belongs_to :sale_item
end
