class Admin::OrdersController < ApplicationController
  layout "admin"

  def index
    if params[:customer_id]
      @orders = Order.where(customer_id: params[:customer_id]).order(created_at: :desc).page(params[:page]).per(10)
    else
      @orders = Order.all.order(created_at: :desc).page(params[:page]).per(10)
    end
  end

  def show
    @order = Order.find(params[:id])
  end

  def update
    @order = Order.find(params[:id])
    @order.update(order_params)
    redirect_to admin_order_path(@order)
  end

  private
  def order_params
    params.require(:order).permit(:order_status)
  end
end
