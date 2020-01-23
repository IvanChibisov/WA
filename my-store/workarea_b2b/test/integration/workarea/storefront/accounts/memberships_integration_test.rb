require 'test_helper'

module Workarea
  module Storefront
    module Accounts
      class MembershipsIntegrationTest < Workarea::IntegrationTest
        setup :set_membership

        def set_membership
          @user = create_user(email: 'bcrouse@workarea.com', password: 'W3bl1nc!')
          @account = create_account
          @membership = create_membership(user: @user, account: @account, role: 'administrator')

          set_current_user(@user)
        end

        def test_create
          post storefront.accounts_memberships_path,
               params: {
                 email: 'test@workarea.com',
                 membership: { role: 'shopper' }
               }

          assert_redirected_to(storefront.accounts_path)

          @account.reload
          assert_equal(2, @account.memberships.length)

          user = User.find_by(email: 'test@workarea.com')
          membership = user.memberships.first

          assert_equal('shopper', membership.role)
          assert_equal(@account.id, membership.account_id)

          assert_equal(2, ActionMailer::Base.deliveries.count)

          email = ActionMailer::Base.deliveries.last
          assert_includes(email.to, 'test@workarea.com')
          assert_includes(
            email.subject,
            I18n.t('workarea.storefront.email.membership_created.subject', account: @account.name)
          )
          assert_includes(
            email.parts.second.body,
            t('workarea.storefront.email.membership_created.new_user_title', account: @account.name)
          )
        end

        def test_update
          membership = create_membership(account: @account, role: 'shopper')

          patch storefront.accounts_membership_path(membership),
                params: {
                  membership: {
                    role: 'approver'
                  }
                }

          assert_redirected_to(storefront.accounts_path)

          membership.reload
          assert_equal('approver', membership.role)
        end

        def test_destroy
          membership = create_membership(account: @account)

          delete storefront.accounts_membership_path(membership)

          assert_redirected_to(storefront.accounts_path)

          @account.reload
          assert_equal(1, @account.memberships.count)
        end

        def test_requires_administator
          @membership.update(role: 'approver')

          post storefront.accounts_memberships_path,
               params: {
                 email: 'test@workarea.com',
                 membership: { role: 'shopper' }
               }

          assert_redirected_to(storefront.accounts_path)
          assert(flash[:info].present?)
          assert_equal(1, @account.reload.memberships.count)
          refute(User.where(email: 'test@workarea.com').exists?)
        end
      end
    end
  end
end
