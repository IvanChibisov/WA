require 'test_helper'

module Workarea
  class B2bCheckoutTest < TestCase
    def test_holding_for_approval
      user = create_user
      product = create_product(variants: [{ sku: 'SKU', regular: 5.to_m }])

      Current.membership = create_membership(user: user, role: :shopper)
      Current.account.update(require_order_approval: true)

      order = create_order(
        items: [{ product_id: product.id, sku: 'SKU' }],
        account_id: Current.account.id
      )

      checkout = Checkout.new(order, user)

      checkout.expects(:complete?).returns(true)
      checkout.expects(:shippable?).returns(true)
      checkout.expects(:payable?).returns(true)
      checkout.inventory.expects(:purchase).returns(true)
      checkout.inventory.expects(:captured?).returns(true)
      checkout.payment_collection.expects(:purchase).returns(true)

      assert(checkout.place_order)
      assert_equal(0, Fulfillment.count)
      assert_equal(:pending_review, order.status)

      order = create_order(
        items: [{ product_id: product.id, sku: 'SKU' }],
        account_id: Current.account.id
      )
      Current.membership.update(role: :approver)

      checkout = Checkout.new(order, user)

      checkout.expects(:complete?).returns(true)
      checkout.expects(:shippable?).returns(true)
      checkout.expects(:payable?).returns(true)
      checkout.inventory.expects(:purchase).returns(true)
      checkout.inventory.expects(:captured?).returns(true)
      checkout.payment_collection.expects(:purchase).returns(true)

      assert(checkout.place_order)
      assert_equal(1, Fulfillment.count)
      assert_equal(:placed, order.status)
      assert(order.reload.reviewed?)
    end
  end
end
