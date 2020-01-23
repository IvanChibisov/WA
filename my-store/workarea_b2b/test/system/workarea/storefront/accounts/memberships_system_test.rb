require 'test_helper'

module Workarea
  module Storefront
    module Accounts
      class MembershipsSystemTest < Workarea::SystemTest
        setup :set_membership

        def set_membership
          @user = create_user(email: 'bcrouse@workarea.com', password: 'W3bl1nc!')
          @account = create_account
          @membership = create_membership(user: @user, account: @account, role: 'administrator')

          visit storefront.login_path

          within '#login_form' do
            fill_in 'email', with: 'bcrouse@workarea.com'
            fill_in 'password', with: 'W3bl1nc!'
            click_button t('workarea.storefront.users.login')
          end
        end

        def test_managing_memberships
          visit storefront.accounts_path

          click_link t('workarea.storefront.accounts.memberships.add_new')

          within '#membership_form' do
            fill_in 'email', with: 'test@workarea.com'
            select 'Shopper', from: 'membership[role]'
            click_button t('workarea.storefront.forms.save')
          end

          assert(page.has_content?('Success'))
          assert(page.has_content?('test@workarea.com'))
          assert(page.has_content?('shopper'))

          click_link 'test@workarea.com'

          within '#membership_form' do
            select 'Approver', from: 'membership[role]'
            click_button t('workarea.storefront.forms.save')
          end

          assert(page.has_content?('Success'))
          assert(page.has_content?('approver'))

          click_button t('workarea.storefront.forms.delete')
          assert(page.has_no_content?('test@workarea.com'))
        end
      end
    end
  end
end
