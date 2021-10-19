class Public::OrdersController < ApplicationController
  def index
  end

  def show
  end

  def new
  end

  def check
    @cart_items = current_customer.cart_items

    receiver =
    case params[:address_number]
    when 1
      current_customer
    when 2
      current_customer.shipping_addresses.find(params[:shipping_address_id])
    when 3
      current_customer.shipping_addresses.create(shipping_address_params)
    else
    end

    @order = current_user.orders.new
    @order.set_receiver(receiver)
    @order.total_price = @cart_items.total_priceaaaaaa + @order.shipping_fee
    @order.payment_method = params[:payment_method]
  end

  def create
    cart_items = current_customer.cart_items.map do |cart_item|
      {
        item_id: cart_item.item_id,
        tax_included_price: cart_item.item.tax_included_price,
        quantity: cart_item.quantity
      }
    end
    current_customer.orders.create(order_params).order_items.create(cart_items)
  end

  def thankyou
  end

  private
  def shipping_address_params
    params.require(:shipping_address).permit(:post_code, :address, :name)
  end
  def order_params
    params.require().permit(:name, :address, :post_code, :total_price, :payment_method)
  end
end
