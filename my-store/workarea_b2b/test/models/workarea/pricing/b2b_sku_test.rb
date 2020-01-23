require 'test_helper'

module Workarea
  module Pricing
    class B2bSkuTest < TestCase
      setup :set_price_list_id

      def set_price_list_id
        Current.price_list_id = 'foo'
      end

      def test_find_price
        sku = Sku.new(id: 'SKU')
        sku.prices.build(min_quantity: 1, regular: 5.to_m)
        sku.prices.build(min_quantity: 5, regular: 3.to_m)

        assert_equal(3.to_m, sku.find_price(quantity: 5).regular)

        sku.prices.build(min_quantity: 1, regular: 4.to_m, price_list_id: 'foo')
        sku.prices.build(min_quantity: 5, regular: 2.to_m, price_list_id: 'foo')

        assert_equal(2.to_m, sku.find_price(quantity: 5).regular)

        Current.price_list_id = nil

        assert_equal(3.to_m, sku.find_price(quantity: 5).regular)
        assert_equal(
          2.to_m,
          sku.find_price(quantity: 5, price_list_id: 'foo').regular
        )
      end
    end
  end
end
