class Public::CartItemsController < ApplicationController

  def create
    @cart_item = current_customer.cart_items.build(item_id: params[:item_id])
    @cart_item.quantity = params[:quantity].to_i
    if @cart_item.save
      redirect_to cart_items_path
    else
      redirect_to request.referer
    end
  end
  
  
  def index
    @cart_items = current_customer.cart_items.all
    @total = @cart_items.inject(0) { |sum, item| sum + item.sum_of_price }
  end
  
  def update
    @cart_item = CartItem.find(params[:id])
    @cart_item.update(quantity: params[:quantity].to_i)
    redirect_to cart_items_path
  end
  
  def destroy
    @cart_item = CartItem.find(params[:id])
    @cart_item.destroy
    redirect_to cart_items_path
  end
  
  def destroy_all
    @cart_items = current_customer.cart_items.all
    @cart_items.destroy_all
    redirect_to cart_items_path
  end
  
end
