require 'test_helper'

module Workarea
  module Storefront
    module Accounts
      class OrdersIntegrationTest < Workarea::IntegrationTest
        setup :set_membership

        def set_membership
          @user = create_user(email: 'bcrouse@workarea.com', password: 'W3bl1nc!')
          @account = create_account(require_order_approval: true)
          @membership = create_membership(user: @user, account: @account, role: 'administrator')

          Current.membership = @membership
          set_current_user(@user)
        end

        def test_is_forbidden_if_order_not_associated_to_account
          order = create_placed_order(account_id: '123')

          get storefront.accounts_order_path(order)
          assert_equal(403, response.status)
        end

        def test_review_approval
          order = create_placed_order(account_id: @account.id)

          patch storefront.review_accounts_order_path(order),
                params: {
                  approve: 'true',
                  notes: 'Looks good.'
                }


          assert_redirected_to(storefront.accounts_order_path(order))

          order.reload
          assert(order.reviewed?)
          assert_equal('Looks good.', order.review_notes)
          assert_equal(@user.id.to_s, order.reviewed_by_id)

          fulfillment = Fulfillment.find(order.id)
          assert_equal(:open, fulfillment.status)

          email = ActionMailer::Base.deliveries.last
          assert_includes(email.to, order.email)
          assert_includes(
            email.subject,
            I18n.t('workarea.storefront.email.account_order_approved.subject', order_id: order.id)
          )
          assert_includes(email.parts.second.body, order.review_notes)
          assert_includes(email.parts.second.body, @user.name)
        end

        def test_review_decline
          order = create_placed_order(account_id: @account.id)

          patch storefront.review_accounts_order_path(order),
                params: {
                  approve: 'false',
                  notes: 'We should hold off on this.'
                }


          assert_redirected_to(storefront.accounts_order_path(order))

          order.reload
          assert(order.reviewed?)
          assert_equal('We should hold off on this.', order.review_notes)
          assert_equal(@user.id.to_s, order.reviewed_by_id)

          fulfillment = Fulfillment.find(order.id)
          assert_equal(:canceled, fulfillment.status)

          email = ActionMailer::Base.deliveries.last
          assert_includes(email.to, order.email)
          assert_includes(
            email.subject,
            I18n.t('workarea.storefront.email.account_order_declined.subject', order_id: order.id)
          )
          assert_includes(email.parts.second.body, order.review_notes)
          assert_includes(email.parts.second.body, @user.name)
        end

        def test_requires_approver
          @membership.update(role: 'shopper')

          order = create_placed_order(account_id: @account.id)

          patch storefront.review_accounts_order_path(order),
                params: {
                  approve: 'true',
                  notes: 'very sneaky'
                }

          assert_redirected_to(storefront.accounts_path)
          assert(flash[:info].present?)

          order.reload
          refute(order.reviewed?)
          refute(order.review_notes.present?)
          refute(order.reviewed_by_id.present?)
        end
      end
    end
  end
end
