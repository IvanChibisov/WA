require 'test_helper'

module Workarea
  module Pricing
    class B2bCollectionTest < TestCase
      setup :set_price_list_id

      def set_price_list_id
        Current.price_list_id = 'foo'
      end

      def test_retail_min_price
        create_pricing_sku(id: 'SKU1', prices: [{ regular: 4.to_m }, { regular: 3.to_m, price_list_id: 'foo' }])
        create_pricing_sku(id: 'SKU2', prices: [{ regular: 6.to_m }])

        assert_equal(4.to_m, Collection.new(%w(SKU1 SKU2)).retail_min_price)
      end

      def test_retail_max_price
        create_pricing_sku(id: 'SKU1', prices: [{ regular: 4.to_m }])
        create_pricing_sku(id: 'SKU2', prices: [{ regular: 6.to_m }, { regular: 7.to_m, price_list_id: 'foo' }])

        assert_equal(6.to_m, Collection.new(%w(SKU1 SKU2)).retail_max_price)
      end

      def test_pricing_list_pricing?
        create_pricing_sku(id: 'SKU1', prices: [{ regular: 4.to_m }])
        refute(Collection.new('SKU1').pricing_list_pricing?)

        create_pricing_sku(id: 'SKU2', prices: [{ regular: 6.to_m }, { regular: 7.to_m, price_list_id: 'foo' }])
        assert(Collection.new(%w(SKU1 SKU2)).pricing_list_pricing?)
      end

      def test_on_sale?
        refute(Collection.new([]).on_sale?)

        create_pricing_sku(
          id: 'SKU1',
          prices: [{ regular: 5.to_m, on_sale: true }, { regular: 4.to_m, price_list_id: 'foo' }]
        )

        refute(Collection.new('SKU1').on_sale?)

        create_pricing_sku(
          id: 'SKU2',
          on_sale: true,
          prices: [{ regular: 5.to_m }, { regular: 4.to_m, on_sale: true, price_list_id: 'foo' }]
        )

        assert(Collection.new(%w(SKU1 SKU2)).on_sale?)
      end

      def test_has_prices?
        refute(Collection.new(['SKU']).has_prices?)

        create_pricing_sku(id: 'SKU1', on_sale: true, prices: [{ regular: 5.to_m }])
        create_pricing_sku(id: 'SKU2', prices: [{ regular: 5.to_m, price_list_id: 'foo' }])
        assert(Collection.new(%w(SKU1 SKU2 SKU3)).has_prices?)
      end

      def test_regular_min_price
        create_pricing_sku(id: 'SKU1', prices: [{ regular: 4.to_m }, { regular: 5.to_m, price_list_id: 'foo' }])
        create_pricing_sku(id: 'SKU2', prices: [{ regular: 6.to_m }])
        assert_equal(5.to_m, Collection.new(%w(SKU1 SKU2)).regular_min_price)
      end

      def test_regular_max_price
        create_pricing_sku(id: 'SKU1', prices: [{ regular: 5.to_m }, { regular: 7.to_m, price_list_id: 'foo' }])
        create_pricing_sku(id: 'SKU2', prices: [{ regular: 6.to_m }])
        assert_equal(7.to_m, Collection.new(%w(SKU1 SKU2)).regular_max_price)
      end
    end
  end
end
