require 'test_helper'

module Workarea
  module Storefront
    module Checkout
      class B2bPaymentViewModelTest < TestCase
        setup :set_checkout

        def set_checkout
          @order = Order.new(email: 'bcrouse@workarea.com')
          @user = User.new(email: 'bcrouse@workarea.com')
          @checkout = Workarea::Checkout.new(@order, @user)
        end

        def test_credit_cards
          profile = Payment::Profile.lookup(PaymentReference.new(@user))
          @checkout.payment.update(profile: profile)

          user_card = create_saved_credit_card(profile: profile)
          step = Workarea::Checkout::Steps::Payment.new(@checkout)

          view_model = Storefront::Checkout::PaymentViewModel.wrap(
            step,
            membership: nil
          )

          assert_equal(user_card, view_model.credit_cards.first.model)

          account = create_account
          membership = create_membership(user: @user, account: account)
          account_profile = Payment::Profile.lookup(PaymentReference.new(account))
          @checkout.payment.update(account_profile: account_profile)

          account_card = create_saved_credit_card(profile: account_profile)


          view_model = Storefront::Checkout::PaymentViewModel.wrap(
            step,
            membership: membership
          )

          assert_equal(2, view_model.credit_cards.size)

          account.update(require_account_payment: true)

          view_model = Storefront::Checkout::PaymentViewModel.wrap(
            step,
            membership: membership
          )

          assert_equal(1, view_model.credit_cards.size)
          assert_equal(account_card, view_model.credit_cards.first.model)
        end
      end
    end
  end
end
