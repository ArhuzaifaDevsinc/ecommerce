class Paypal::CheckoutsController < ApplicationController
    require 'paypal-sdk-rest'
    include PayPal::SDK::REST
    include PayPal::SDK::OpenIDConnect

  def create
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
            total: 234.0,
            currency: 'MXN'
          },
          description:'paypal payment transaction description.',
          item_list: {
            items: @cart.map(&:to_paypal)
          }
        }
      ]
    })
    

    if payment.create
      redirect_url = payment.links.find {|v| v.rel == 'approval_url'}.href
      byebug
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