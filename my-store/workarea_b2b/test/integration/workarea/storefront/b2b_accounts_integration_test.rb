require 'test_helper'

module Workarea
  module Storefront
    class B2bAccountsIntegrationTest < Workarea::IntegrationTest
      setup :set_membership

      def set_membership
        @user = create_user(email: 'bcrouse@workarea.com', password: 'W3bl1nc!')
        @account = create_account
        @membership = create_membership(user: @user, account: @account, role: 'administrator')

        set_current_user(@user)
      end

      def test_update
        patch storefront.accounts_path,
              params: {
                require_account_address: 'true',
                require_account_payment: 'true',
                require_order_approval: 'true'
              }

        assert_redirected_to(storefront.accounts_path)

        @account.reload
        assert(@account.require_account_address?)
        assert(@account.require_account_payment?)
        assert(@account.require_order_approval?)
      end

      def test_displays_current_membership_account
        membership_two = create_membership(user: @user)

        get storefront.accounts_path

        assert_select(
          'h1',
          text: t(
            'workarea.storefront.accounts.title',
            account: @account.name
          )
        )

        patch storefront.membership_path,
              params: { membership_id: membership_two.id },
              headers: { 'Referer' => storefront.accounts_path }

        follow_redirect!

        assert_select(
          'h1',
          text: t(
            'workarea.storefront.accounts.title',
            account: membership_two.account.name
          )
        )
      end

      def test_requires_administator
        @membership.update(role: 'approver')

        patch storefront.accounts_path,
              params: {
                require_account_address: 'true'
              }

        assert_redirected_to(storefront.accounts_path)
        assert(flash[:info].present?)

        @account.reload
        refute(@account.require_account_address?)
      end
    end
  end
end
