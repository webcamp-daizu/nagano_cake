class Public::ShippingAddressesController < ApplicationController

  def index
    @address = ShippingAddress.new
    @addresses = current_customer.shipping_addresses.all
    p @blogs
  end
  
  def create
    @address = ShippingAddress.new(address_params)
    @address.customer_id = current_customer.id
    if @address.save
      redirect_to shipping_addresses_path
    else
      @addresses = current_customer.shipping_addresses.all
      render :index
    end
  end

  def edit
    @address = ShippingAddress.find(params[:id])
  end
  
  def update
    @address = ShippingAddress.find(params[:id])
    if @address.update
      redirect_to shipping_addresses_path
    else
      render :edit
    end
  end
  
  def destroy
    @address = ShippingAddress.find(params[:id])
    @address.destroy
    redirect_to shipping_addresses_path
  end
  
  private
  def address_params
    params.permit(:name,:address,:post_code)
  end
  
end
