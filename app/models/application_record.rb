# frozen_string_literal: true

class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true
  def to_paypal
    {
      name: self.title,
      sku: self.id,
      price: self.price,
      currency: 'MXN',
      quantity: '1'
    }
  end
end
