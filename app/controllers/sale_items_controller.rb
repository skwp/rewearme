class SaleItemsController < ApplicationController
  def index
    params[:currency] ||= "USD"
    params[:category] ||= "All"

    @sale_items = SaleItem

    if params[:category] && params[:category] != 'All'
      @sale_items = @sale_items.where("upper(category) LIKE upper(?)", params[:category])
    end

    if params[:brand]
      @sale_items = @sale_items.where("upper(brand) LIKE upper(?)", params[:brand])
    end

    if params[:query]
      @sale_items = @sale_items.where("upper(title) like upper(?)", "%#{params[:query]}%")
    else
      @sale_items = @sale_items.all
    end

    @brands = SaleItem.group(:brand).select(:brand).map(&:brand).compact.sort
    @categories = SaleItem.group(:category).select(:category).map{|cat| cat.category.titleize}.uniq.compact.sort
  end
end
