require 'test_helper'

module Workarea
  class B2bOrdersIntegrationTest < Workarea::IntegrationTest
    def test_reorder
      user = create_user
      set_current_user(user)

      order = create_placed_order(user_id: user.id)
      post storefront.reorder_order_path(order)
      assert_redirected_to(storefront.cart_path)
      assert(flash[:success].present?)

      order = create_placed_order(id: '235')
      post storefront.reorder_order_path(order)
      assert_equal(403, response.status)
    end
  end
end
