class Admin::SearchesController < ApplicationController
  layout "admin"

  def search
    @items = Item.search(params[:keyword]).page(params[:page]).per(10)
    @keyword = params[:keyword]
  end
end
