class Public::CustomersController < ApplicationController
  before_action :authenticate_customer! 
  
  def show
    @customer = current_customer
  end
  
  def withdraw_confirm
    @customer = current_customer
  end
  
  def withdraw
    customer = current_customer
    if customer.update(is_deleted: true)
      reset_session
      redirect_to root_path
    end
  end

end
