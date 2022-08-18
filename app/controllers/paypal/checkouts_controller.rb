# frozen_string_literal: true

module Paypal
  class CheckoutsController < ApplicationController
    before_action :check_cart, only: %i[create]

    require 'paypal-sdk-rest'
    include PayPal::SDK::REST
    include PayPal::SDK::OpenIDConnect

    def create
      unless user_signed_in?
        redirect_to new_user_session_path, alert: 'Please authenticate first in order to checkout!' and return
      end
      if helpers.cart_inspection
        redirect_to carts_path,
                    alert: 'User can not checkout with his own items on cart!' and return
      end

      @payment = Payment.new({
                               intent: 'sale',
                               payer: {
                                 payment_method: 'paypal'
                               },
                               redirect_urls: {
                                 return_url: complete_paypal_checkouts_url,
                                 cancel_url: root_url
                               },
                               transactions: [
                                 {
                                   amount: {
                                     total: helpers.cart_total,
                                     currency: 'JPY'
                                   },
                                   description: ' CART ITEMS DETAIL.',
                                   item_list: {
                                     items: helpers.wrapping_items
                                   }
                                 }
                               ]
                             })
      if @payment.create
        redirect_url = @payment.links.find { |v| v.rel == 'approval_url' }.href
        redirect_to redirect_url
      else
        redirect_to carts_path, alert: 'Something went wrong!Please try again!' and return
      end
    end

    private

    def check_cart
      if @cart.empty?
        redirect_to carts_path, alert: 'In order to checkout, Please add some items to the cart!' and return
      end
    end

    def complete
      @payment = Payment.find(params[:paymentId])
      if @payment.execute(payer_id: params[:PayerID])
        session[:cart] = nil

        redirect_to root_path, notice: 'Thanks for Successful Purchasing!'
      else
        redirect_to root_path, alert: 'There was a problem processing your payment!'
      end
    end
  end
end
