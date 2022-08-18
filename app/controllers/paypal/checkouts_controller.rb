class Paypal::CheckoutsController < ApplicationController
    require 'paypal-sdk-rest'
    include PayPal::SDK::REST
    include PayPal::SDK::OpenIDConnect

  def create 
    unless user_signed_in?
      redirect_to new_user_session_path, alert:'Please authenticate first in order to checkout!' and return
    end
    payment = Payment.new({
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
          description:'paypal payment transaction description.',
          item_list: {
            items: helpers.wrapping_items
          }
        }
      ]
    })

    if payment.create
      redirect_url = payment.links.find {|v| v.rel == 'approval_url'}.href
      redirect_to redirect_url
    else
      redirect_to root_path, alert:'Something went wrong with the payment process,please try again!'
    end
  end
  
  def complete
    payment = Payment.find(params[:paymentId])
    if payment.execute(payer_id: params[:PayerID])
        session[:cart] = nil
      
        redirect_to root_path, notice: 'Thanks for Successful Purchasing!'
    else
        redirect_to root_path, alert: 'There was a problem processing your payment!'
    end
  end
end