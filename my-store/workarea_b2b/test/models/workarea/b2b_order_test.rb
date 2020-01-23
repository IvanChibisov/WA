require 'test_helper'

module Workarea
  class B2bOrderTest < TestCase
    def test_auto_reviewed?
      order = Order.new
      assert(order.reviewed?)
      assert(order.auto_reviewed?)

      order.account_id = '0001'
      refute(order.reviewed?)
      refute(order.auto_reviewed?)

      order.review!('123')
      assert(order.reviewed?)
      refute(order.auto_reviewed?)

      order.reviewed_by_id = nil
      assert(order.reviewed?)
      assert(order.auto_reviewed?)
    end
  end
end
