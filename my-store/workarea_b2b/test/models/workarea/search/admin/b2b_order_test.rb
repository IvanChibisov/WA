require 'test_helper'

module Workarea
  module Search
    class Admin
      class B2bOrderTest < TestCase
        def test_keywords_include_purchase_order_number
          order = create_order
          payment = create_payment(
            id: order.id,
            terms: { amount: 1.to_m, purchase_order_number: 'PO123' }
          )

          model = Search::Admin::Order.new(order)
          assert_includes(model.keywords, 'PO123')
        end
      end
    end
  end
end
