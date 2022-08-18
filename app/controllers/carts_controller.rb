class CartsController < ApplicationController

  def add_to
    @item = Item.find(params[:id])
    begin
      if current_user.id == @item.user.id
        redirect_to root_path ,alert: 'User cannot add his own product into cart!' and return
      end
    rescue
    #  'Please authenticate for complete access of Shop!'
    end
    session[:cart][params[:id].to_i] = 1
    redirect_to request.referer
  end

  def remove_from
    return if params[:id].nil?
    session[:cart].delete(params[:id])
    redirect_to request.referer
  end

  def update_quantity
    return if params[:quantity].nil?
    session[:cart][params[:id].to_i] = params[:quantity]
    redirect_to request.referer
  end
  
  def show_
  end
end
