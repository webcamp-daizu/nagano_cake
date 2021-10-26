class Public::ShippingAddressesController < ApplicationController

  def index
    @address = ShippingAddress.new
    @addresses = current_customer.shipping_addresses.all
  end

  def create
    @address = ShippingAddress.new(address_params)
    @address.customer_id = current_customer.id
    if @address.save
      redirect_to shipping_addresses_path ,notice: "新しい配送先を登録しました"
    else
      @addresses = current_customer.shipping_addresses.all
      flash[:alert] = '配送先の登録に失敗しました'
      render :index
    end
  end

  def edit
    @address = ShippingAddress.find(params[:id])
  end

  def update
    @address = ShippingAddress.find(params[:id])
    if @address.update(address_params)
      redirect_to shipping_addresses_path ,notice: "配送先の情報を変更しました"
    else
      flash[:alert] = '配送先の変更に失敗しました'
      render :edit
    end
  end

  def destroy
    @address = ShippingAddress.find(params[:id])
    @address.destroy
    redirect_to shipping_addresses_path, notice: '1件の配送先を削除しました'
  end

  private
  def address_params
    params.require(:shipping_address).permit(:name,:address,:post_code)
  end

end
