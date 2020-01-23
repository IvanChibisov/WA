require 'test_helper'

module Workarea
  module Storefront
    class B2bCheckoutsIntegrationTest < Workarea::IntegrationTest
      def test_set_order_account
        user = create_user
        membership = create_membership(user: user)
        set_current_user(user)

        product = create_product
        shipping_service = create_shipping_service

        post storefront.cart_items_path,
             params: {
               product_id: product.id,
               sku: product.skus.first,
               quantity: 2
             }

        order = Order.last
        assert_nil(order.account_id)

        patch storefront.checkout_addresses_path,
              params: {
                shipping_address: factory_defaults(:shipping_address),
                billing_address: factory_defaults(:billing_address)
              }

        get storefront.checkout_path
        assert_redirected_to(storefront.checkout_addresses_path)
        assert_equal(membership.account.id.to_s, order.reload.account_id)
      end
    end
  end
end
