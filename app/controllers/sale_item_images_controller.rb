class SaleItemImagesController < ApplicationController
  def index
    respond_to do |format|
      format.json {
        render :json => SaleItem.find(params[:sale_item_id]).images
      }
    end
  end
end
