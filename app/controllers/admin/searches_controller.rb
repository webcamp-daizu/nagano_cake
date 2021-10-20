class Admin::SearchesController < ApplicationController
  before_action:authenticate_admin!
  layout "admin"
  
  def search
    @items = Item.search(params[:keyword]).page(params[:page]).per(10)
    @keyword = params[:keyword]
  end
end
