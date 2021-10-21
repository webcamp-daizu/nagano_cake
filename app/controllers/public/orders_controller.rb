class Public::OrdersController < ApplicationController
  before_action :authenticate_customer!
  before_action :check_cart_is_not_empty, except: [:index, :show]

  def index
    @orders = current_customer.orders
  end

  def show
    @order = current_customer.orders.find(params[:id])
  end

  def new
    @order = current_customer.orders.new
    @shipping_address = ShippingAddress.new
  end

  def check
    @order = current_customer.orders.new
    @order.payment_method = params[:payment_method]
    @order.total_price = current_customer.cart_items_total_price + @order.shipping_fee

    receiver =
    case @address_number = params[:address_number].to_i
    when 1 # ご自身の住所
      current_customer
    when 2 # 登録済み住所から選択
      current_customer.shipping_addresses.find(params[:shipping_address_id])
    when 3 # 新しいお届け先
      @shipping_address = current_customer.shipping_addresses.new(shipping_address_params)
      unless @shipping_address.save
        render :new
        return
      else
        @shipping_address
      end
    else
    end
    @order.set_receiver(receiver)
  end

  def create
    order = current_customer.orders.create(order_params)
    redirect_to thankyou_orders_path
  end

  def thankyou
  end

  private

  def shipping_address_params
    params.permit(:post_code, :address, :name)
  end

  def order_params
    params.require(:order).permit(:name, :address, :post_code, :total_price, :payment_method)
  end

  def check_cart_is_not_empty
    redirect_to items_path unless current_customer.cart_items.present?
  end
end
