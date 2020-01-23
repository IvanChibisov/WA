require 'test_helper'

module Workarea
  module Pricing
    class B2bPriceTest < TestCase
      def test_generic?
        price = Price.new(regular: 2.to_m, min_quantity: 1)
        assert(price.generic?)

        price.price_list_id = 'foo'
        refute(price.generic?)
      end

      def test_generic_for_price_list?
        price = Price.new(regular: 2.to_m, min_quantity: 1)
        refute(price.generic_for_price_list?)

        price.price_list_id = 'foo'
        assert(price.generic_for_price_list?)
      end
    end
  end
end
