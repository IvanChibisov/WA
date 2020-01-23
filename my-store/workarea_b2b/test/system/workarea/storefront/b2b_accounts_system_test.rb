require 'test_helper'

module Workarea
  module Storefront
    class B2bAccountsSystemTest < Workarea::SystemTest
      setup :set_membership

      def set_membership
        @user = create_user(email: 'bcrouse@workarea.com', password: 'W3bl1nc!')
        @account = create_account(require_order_approval: true, name: 'Foo')
        @membership = create_membership(user: @user, account: @account, role: 'administrator')

        visit storefront.login_path

        within '#login_form' do
          fill_in 'email', with: 'bcrouse@workarea.com'
          fill_in 'password', with: 'W3bl1nc!'
          click_button t('workarea.storefront.users.login')
        end
      end

      def test_switching_accounts
        create_membership(user: @user, account: create_account(name: 'Bar'))

        visit storefront.root_path
        click_link t('workarea.storefront.accounts.title', account: 'Foo')

        within '#switch_account_form' do
          select 'Bar', from: 'membership_id'
        end

        assert(
          page.has_content?(
            t('workarea.storefront.accounts.title', account: 'Bar')
          )
        )
      end

      def test_editing_account_details
        visit storefront.accounts_path

        click_link t('workarea.storefront.forms.update')

        within '#account_form' do
          assert(has_content?(t('workarea.storefront.accounts.edit.disabled_address_requirement')))
          assert(has_content?(t('workarea.storefront.accounts.edit.disabled_payment_requirement')))
          check 'require_order_approval'
          click_button t('workarea.storefront.forms.save')
        end

        assert(page.has_content?('Success'))
        assert(page.has_content?('Yes', count: 1))

        @account.addresses.create!(factory_defaults(:shipping_address))
        profile = Payment::Profile.lookup(PaymentReference.new(@account))
        create_saved_credit_card(profile: profile)

        click_link t('workarea.storefront.forms.update')

        within '#account_form' do
          refute(has_content?(t('workarea.storefront.accounts.edit.disabled_address_requirement')))
          refute(has_content?(t('workarea.storefront.accounts.edit.disabled_payment_requirement')))
          check 'require_account_address'
          check 'require_account_payment'
          uncheck 'require_order_approval'
          click_button t('workarea.storefront.forms.save')
        end

        assert(page.has_content?('Success'))
        assert(page.has_content?('Yes', count: 2))
      end

      def test_account_dashboard
        create_membership(account: @account, role: 'shopper')
        create_membership(account: @account, role: 'approver')

        @account.auto_save_shipping_address(
          first_name: 'Ben',
          last_name: 'Crouse',
          street: '22 S. 3rd St.',
          street_2: 'Second Floor',
          city: 'Philadelphia',
          region: 'PA',
          postal_code: '19106',
          country: 'US',
          phone_number: '2159251800'
        )

        @account.auto_save_billing_address(
          first_name: 'Ben',
          last_name: 'Crouse',
          street: '1019 S. 47th St.',
          city: 'Philadelphia',
          region: 'PA',
          postal_code: '19143',
          country: 'US',
          phone_number: '2159251800'
        )

        create_placed_order(
          id: 'ORDER_1234',
          user_id: @user.id,
          account_id: @account.id
        )

        fulfilled_order = create_placed_order(
          id: 'ORDER_5678',
          user_id: @user.id,
          account_id: @account.id
        )
        shipped_item = fulfilled_order.items.first
        fulfillment = Fulfillment.find(fulfilled_order.id)
        fulfillment.ship_items('1Z', [
          { 'id' => shipped_item.id, 'quantity' => shipped_item.quantity }
        ])

        visit storefront.accounts_path

        assert(page.has_content?('ORDER_1234'))
        assert(page.has_content?('Pending Review'))
        assert(page.has_content?('ORDER_5678'))
        assert(page.has_content?('Shipped'))
        assert(page.has_content?(t('workarea.storefront.orders.track_package')))
        assert(page.has_content?('22 S. 3rd St.'))
        assert(page.has_content?('1019 S. 47th St.'))
        assert(page.has_content?('shopper'))
        assert(page.has_content?('approver'))
      end

      def test_account_dashboard_as_non_administrator
        create_placed_order(user_id: @user.id, account_id: @account.id)

        @membership.update(role: 'shopper')

        visit storefront.accounts_path

        assert(page.has_no_content?(t('workarea.storefront.forms.update')))
        assert(page.has_no_content?(t('workarea.storefront.accounts.memberships.add_new')))
        assert(page.has_no_content?(t('workarea.storefront.users.add_address')))
        assert(page.has_no_content?(t('workarea.storefront.users.add_credit_card')))
        assert(page.has_content?(t('workarea.storefront.accounts.orders.view_all')))
        assert(page.has_content?(t('workarea.storefront.users.order_history')))
        assert(page.has_content?("#{t('workarea.storefront.accounts.orders.pending_orders')} (1)"))

        @account.update(require_order_approval: false)
        visit storefront.edit_users_account_path
        assert(page.has_no_content?(t('workarea.storefront.accounts.orders.view_all')))
        assert(page.has_no_content?("#{t('workarea.storefront.accounts.orders.pending_orders')} (1)"))
      end
    end
  end
end
