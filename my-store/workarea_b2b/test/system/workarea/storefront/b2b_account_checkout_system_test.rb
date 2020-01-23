require 'test_helper'

module Workarea
  module Storefront
    class B2bAccountCheckoutSystemTest < Workarea::SystemTest
      include Storefront::SystemTest

      setup :setup_checkout_specs,
            :add_user_data,
            :add_account_data

      def add_account_data
        @account = create_account(credit_limit: 100.to_m)
        @user = User.find_by_email('bcrouse@workarea.com')

        create_membership(account: @account, user: @user)

        @account.auto_save_shipping_address(
          first_name: 'Robert',
          last_name: 'Clams',
          street: '12 N. 3rd St.',
          city: 'Philadelphia',
          region: 'PA',
          postal_code: '19106',
          country: 'US',
          phone_number: '2159251800'
        )

        @account.auto_save_billing_address(
          first_name: 'Robert',
          last_name: 'Clams',
          street: '100 Market St.',
          city: 'Philadelphia',
          region: 'PA',
          postal_code: '19106',
          country: 'US',
          phone_number: '2159251800'
        )

        @profile = Payment::Profile.lookup(PaymentReference.new(@account))
        @account_card = @profile.credit_cards.create!(
          first_name: 'Robert',
          last_name: 'Clams',
          number: '1',
          month: 1,
          year: Time.current.year + 2,
          cvv: '999'
        )
      end

      def test_completing_checkout_with_account_details
        Workarea.with_config do |config|
          config.payment_terms = {
            'Credit card or terms' => %i(credit_card terms),
          }

          @account.update(
            require_account_address: true,
            require_account_payment: true,
            payment_terms: 'Credit card or terms'
          )

          start_user_checkout
          assert_current_path(storefront.checkout_addresses_path)

          click_button t('workarea.storefront.checkouts.continue_to_shipping')
          click_button t('workarea.storefront.checkouts.continue_to_payment')

          assert(page.has_content?('Robert'))
          assert(page.has_content?('Clams'))
          assert(page.has_content?('100 Market St.'))
          assert(page.has_content?('Philadelphia'))
          assert(page.has_content?('19106'))
          assert(page.has_content?('PA'))
          assert(page.has_content?('US'))
          assert(page.has_content?('215-925-1800'))

          assert(page.has_content?('Robert'))
          assert(page.has_content?('Clams'))
          assert(page.has_content?('12 N. 3rd St.'))
          assert(page.has_content?('Philadelphia'))
          assert(page.has_content?('19106'))
          assert(page.has_content?('PA'))
          assert(page.has_content?('US'))
          assert(page.has_content?('215-925-1800'))

          assert(find_field("payment_#{@account_card.id}"))
          choose 'payment_terms'
          fill_in 'terms[purchase_order_number]', with: 'PO123456'

          assert(page.has_content?('Integration Product'))
          assert(page.has_content?('SKU'))

          assert(page.has_content?('$5.00')) # Subtotal
          assert(page.has_content?('$7.00')) # Shipping
          assert(page.has_content?('$0.84')) # Tax
          assert(page.has_content?('$12.84')) # Total

          click_button t('workarea.storefront.checkouts.place_order')

          assert_current_path(storefront.checkout_confirmation_path)
          assert(page.has_content?('Success'))
          assert(page.has_content?(t('workarea.storefront.orders.terms')))
          assert(page.has_content?('PO123456'))
        end
      end

      def test_checking_out_without_account_details
        @account.update(
          require_account_address: true,
          require_account_payment: true,
          payment_terms: nil,
          addresses: []
        )
        @profile.update(credit_cards: [])
        @user.update(addresses: [])

        start_user_checkout
        assert_current_path(storefront.checkout_addresses_path)

        fill_in_shipping_address
        uncheck 'same_as_shipping'
        fill_in_billing_address
        click_button t('workarea.storefront.checkouts.continue_to_shipping')

        assert(page.has_content?('Success'))

        click_button t('workarea.storefront.checkouts.continue_to_payment')

        assert_current_path(storefront.checkout_payment_path)
        assert(page.has_content?('Success'))

        assert(page.has_content?('22 S. 3rd St.'))
        assert(page.has_content?('Philadelphia'))
        assert(page.has_content?('PA'))
        assert(page.has_content?('19106'))
        assert(page.has_content?('Ground'))

        assert(page.has_content?('Integration Product'))
        assert(page.has_content?('SKU'))

        assert(page.has_content?('$5.00')) # Subtotal
        assert(page.has_content?('$7.00')) # Shipping
        assert(page.has_content?('$0.84')) # Tax
        assert(page.has_content?('$12.84')) # Total

        choose 'payment_new_card'
        fill_in_credit_card
        click_button t('workarea.storefront.checkouts.place_order')

        assert_current_path(storefront.checkout_confirmation_path)
      end
    end
  end
end
