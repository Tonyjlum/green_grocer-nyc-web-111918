require "pry"
require "byebug"
def consolidate_cart(cart)
  cart_hsh = {}
  cart.each do |item|
    item.each do |name, values|
      values.each do |k1, v1|
        cart_hsh[name] = {} if cart_hsh[name].nil?
        cart_hsh[name][k1] = v1
      end
      if cart_hsh[name][:count].nil?
        cart_hsh[name][:count] = 1
      else
        cart_hsh[name][:count] +=1
      end
    end
  end
  cart_hsh
end

def apply_coupons(cart, coupons)
  coupons.each do |coupon|
    if cart.keys.include?(coupon[:item])
      cart["#{coupon[:item]} W/COUPON"] = {}
    end
  end
  cart.each do |item, tags|
    coupons.each do |coupon|
      if item == coupon[:item]
        if cart[item][:count] >= coupon[:num]
          #account for less items than coupon?
          cart[item][:count] -= coupon[:num]
          if cart["#{item} W/COUPON"][:count].nil?
            cart["#{item} W/COUPON"] = {
              price: coupon[:cost],
              clearance: tags[:clearance],
              count: 1}
          else
            cart["#{item} W/COUPON"][:count] += 1
          end
        end
      end
    end
  end
  cart
end

def apply_clearance(cart)
  cart.each do |name, tags|
    if cart[name][:clearance]
      cart[name][:price] = (cart[name][:price] * 0.8).round(2)
    end
  end
  cart
end

def checkout(cart, coupons)
  total = 0
  cart = consolidate_cart(cart)
  cart = apply_coupons(cart,coupons)
  cart = apply_clearance(cart)

  cart.each do |item,tags|
    # binding.pry
    cart[item][:count].times do
     total += cart[item][:price]
   end
  end

  total > 100 ? total * 0.9 : total

end
