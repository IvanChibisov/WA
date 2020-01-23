require 'test_helper'

module Workarea
  module Storefront
    module Accounts
      class OrdersSystemTest < Workarea::SystemTest
        setup :set_membership

        def set_membership
          @user = create_user(email: 'bcrouse@workarea.com', password: 'W3bl1nc!')
          @account = create_account(require_order_approval: true)
          @membership = create_membership(user: @user, account: @account, role: 'administrator')

          visit storefront.login_path

          within '#login_form' do
            fill_in 'email', with: 'bcrouse@workarea.com'
            fill_in 'password', with: 'W3bl1nc!'
            click_button t('workarea.storefront.users.login')
          end
        end

        def test_approving_an_order
          order = create_placed_order(account_id: @account.id)

          visit storefront.accounts_path

          click_link t('workarea.storefront.orders.review'), match: :first

          within '#review_order_form' do
            fill_in 'notes', with: 'accepting order note'
            click_button t('workarea.storefront.accounts.orders.approve')
          end

          assert(page.has_content?('Open'))
          assert(page.has_content?(t('workarea.storefront.orders.reviewed_by')))
          assert(page.has_content?('accepting order note'))
        end

        def test_declining_an_order
          order = create_placed_order(account_id: @account.id)

          visit storefront.accounts_path

          click_link t('workarea.storefront.orders.review'), match: :first

          within '#review_order_form' do
            fill_in 'notes', with: 'declining order note'
            click_button t('workarea.storefront.accounts.orders.decline')
          end

          assert(page.has_content?('Canceled'))
          assert(page.has_content?(t('workarea.storefront.orders.reviewed_by')))
          assert(page.has_content?('declining order note'))
        end

        def test_reordering
          create_placed_order(account_id: @account.id)

          visit storefront.accounts_path

          click_link t('workarea.storefront.orders.reorder'), match: :first

          assert_current_path(storefront.cart_path)
          assert(page.has_content?('Success'))
          assert(page.has_content?('Test Product'))
          assert(page.has_content?('SKU'))
          assert(page.has_content?('$10.00'))
        end
      end
    end
  end
end
