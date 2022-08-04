# frozen_string_literal: true

class ApplicationController < ActionController::Base

    before_action :configure_permitted_parameters,
        if: :devise_controller?

    include Pundit::Authorization
    rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized
    before_action :initialize_session
    before_action :load_cart
  private

  def user_not_authorized
    flash[:alert] = "You are not authorized to perform this action."
    redirect_back(fallback_location: root_path)
  end

        protected
        def configure_permitted_parameters
            devise_parameter_sanitizer.permit(:sign_up, keys: [:image])
            devise_parameter_sanitizer.permit(:account_update, keys: [:image])
        end

  def initialize_session
    session[:cart] ||= {}
  end

  def load_cart
    @cart = Item.find(session[:cart].keys)
    @item_quantity = session[:cart].values
  end
end
