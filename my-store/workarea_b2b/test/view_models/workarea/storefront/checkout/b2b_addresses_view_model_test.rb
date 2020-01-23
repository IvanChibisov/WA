require 'test_helper'

module Workarea
  module Storefront
    module Checkout
      class B2bAddressesViewModelTest < TestCase
        setup :set_checkout

        def set_checkout
          @order = Order.new(email: 'bcrouse@workarea.com')
          @user = create_user(email: 'bcrouse@workarea.com')
          @checkout = Workarea::Checkout.new(@order, @user)
        end

        def test_saved_addresses
          account = create_account
          membership = create_membership(account: account, user: @user)
          step = Workarea::Checkout::Steps::Addresses.new(@checkout)

          address_params =
            Workarea.config.testing_factory_defaults.shipping_address

          user_address = @user.addresses.create!(address_params)
          account_address = account.addresses.create!(address_params)

          view_model = Workarea::Storefront::Checkout::AddressesViewModel.new(
            step,
            membership: nil
          )

          assert_equal(user_address.id, view_model.saved_addresses.first.id)

          view_model = Workarea::Storefront::Checkout::AddressesViewModel.new(
            step,
            membership: membership
          )

          assert_equal(2, view_model.saved_addresses.size)

          account.update(require_account_address: true)

          view_model = Workarea::Storefront::Checkout::AddressesViewModel.new(
            step,
            membership: membership
          )

          assert_equal(1, view_model.saved_addresses.size)
          assert_equal(account_address.id, view_model.saved_addresses.first.id)
        end
      end
    end
  end
end
