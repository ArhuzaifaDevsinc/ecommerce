module CheckoutsHelper

    def cart_total
      i=0
      @total = 0
      @cart.each do |item|
        @total += item.price.to_f * @item_quantity[i].to_f
        i += 1
      end
      return @total
    end
    
    def wrapping_items
        temp = 0
        hash = []
        @cart.each do |item|
            hash.push({
            :name => item.title,
            :sku => item.id,
            :price => item.price,
            :currency => 'JPY',
            :quantity => @item_quantity[temp]
            })
            temp += 1
        end
        return hash
    end
end
