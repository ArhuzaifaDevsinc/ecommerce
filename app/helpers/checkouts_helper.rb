# frozen_string_literal: true

module CheckoutsHelper
  def cart_total
    i = 0
    total = 0
    @cart.each do |item|
      total += item.price.to_f * @item_quantity[i].to_f
      i += 1
    end
    total
  end

  def wrapping_items
    temp = 0
    hash = []
    @cart.each do |item|
      hash.push({
                  name: item.title,
                  sku: item.id,
                  price: item.price,
                  currency: 'JPY',
                  quantity: @item_quantity[temp]
                })
      temp += 1
    end
    hash
  end

  def cart_inspection
    check = false
    @cart.each do |item|
      check = true if current_user.id == item.user.id
    end
    check
  end
end
