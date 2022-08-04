class CartsController < ApplicationController

  def add_to
    session[:cart][params[:id].to_i] = 1
    redirect_to request.referer
  end

  def remove_from
        # delete_item_from_session
    return if params[:id].nil?
    session[:cart].delete(params[:id])
    redirect_to request.referer
  end

  def update_quantity
    return if params[:quantity].nil?
    session[:cart][params[:id].to_i] = params[:quantity]
    redirect_to request.referer
  end
end
