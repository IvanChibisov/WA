require 'test_helper'

module Workarea
  module Admin
    class MembershipsIntegrationTest < Workarea::IntegrationTest
      include Admin::IntegrationTest

      def test_create
        account = create_account
        user = create_user

        post admin.organization_memberships_path,
             params: {
               return_to: admin.memberships_user_path(user),
               user_id: user.id,
               membership: {
                 account_id: account.id,
                 role: 'shopper',
               }
             }

        assert_redirected_to(admin.memberships_user_path(user))
        assert(flash[:success].present?)

        membership = Organization::Membership.last
        assert_equal(account, membership.account)
        assert_equal(user, membership.user)
        assert_equal('shopper', membership.role)

        account_two = create_account
        post admin.organization_memberships_path,
             params: {
               email: user.email,
               membership: {
                 account_id: account_two.id,
                 role: 'administrator',
               }
             }

        assert_redirected_to(admin.memberships_organization_account_path(account_two))
        assert(flash[:success].present?)

        user.reload
        assert_equal(2, user.memberships.count)
        assert_equal(user, account_two.memberships.first.user)
        assert_equal('administrator', account_two.memberships.first.role)
        assert(user.signup_complete?)

        post admin.organization_memberships_path,
             params: {
               email: 'testing@workarea.com',
               membership: {
                 account_id: account.id,
                 role: 'shopper',
               }
             }

        assert_redirected_to(admin.memberships_organization_account_path(account))
        assert(flash[:success].present?)

        user = User.find_by_email('testing@workarea.com')
        assert_equal(1, user.memberships.count)
        assert_equal(account, user.memberships.first.account)
        assert_equal('shopper', user.memberships.first.role)
        refute(user.signup_complete?)
      end

      def test_update
        membership = create_membership(role: 'shopper', default: false)

        put admin.organization_membership_path(membership),
            params: {
              return_to: admin.memberships_user_path(membership.user),
              membership: {
                role: 'approver',
                default: true
              }
            }

        assert_redirected_to(admin.memberships_user_path(membership.user))
        assert(flash[:success].present?)

        membership.reload
        assert_equal('approver', membership.role)
        assert(membership.default?)
      end

      def test_destroy
        membership = create_membership
        account = membership.account

        delete admin.organization_membership_path(membership)

        assert_equal(0, Organization::Membership.count)
        assert_redirected_to(admin.memberships_organization_account_path(account))
        assert(flash[:success].present?)
      end
    end
  end
end
