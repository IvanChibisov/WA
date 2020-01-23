require 'test_helper'

module Workarea
  if Plugin.installed?('Workarea::Api::Admin')
    module Api
      module Admin
        class MembershipsIntegrationTest < IntegrationTest
          include Workarea::Admin::IntegrationTest


          def user_membership_attributes
            @user_membership_attributes ||= create_membership.as_json.except('_id', 'user_id')
          end

          def account_membership_attributes
            @account_membership_attributes ||= create_membership.as_json.except('_id', 'account_id')
          end

          #
          # User
          #

          def test_lists_user_memberships
            user = create_user
            memberships = [
              create_membership(user: user),
              create_membership(user: user),
              create_membership
            ]

            get admin_api.user_memberships_path(user)
            result = JSON.parse(response.body)['memberships']

            assert_equal(2, result.length)
            assert_equal(memberships.second, Organization::Membership.new(result.first))
            assert_equal(memberships.first, Organization::Membership.new(result.second))
          end

          def test_creates_user_membership
            user = create_user
            attrs = user_membership_attributes

            assert_difference 'Organization::Membership.count', 1 do
              post admin_api.user_memberships_path(user),
                   params: { membership: attrs }
            end
          end

          def test_shows_user_membership
            membership = create_membership

            get admin_api.user_membership_path(membership.user, membership)
            result = JSON.parse(response.body)['membership']
            assert_equal(membership, Organization::Membership.new(result))
          end

          def test_updates_user_membership
            membership = create_membership(role: 'administrator')

            patch admin_api.user_membership_path(membership.user, membership),
                  params: { membership: { role: 'shopper' } }

            membership.reload
            assert_equal('shopper', membership.role)
          end

          def test_destroys_user_memberships
            membership = create_membership

            assert_difference 'Organization::Membership.count', -1 do
              delete admin_api.user_membership_path(membership.user, membership)
            end
          end

          #
          # Account
          #

          def test_lists_account_memberships
            account = create_account
            memberships = [
              create_membership(account: account),
              create_membership(account: account),
              create_membership
            ]

            get admin_api.account_memberships_path(account)
            result = JSON.parse(response.body)['memberships']

            assert_equal(2, result.length)
            assert_equal(memberships.second, Organization::Membership.new(result.first))
            assert_equal(memberships.first, Organization::Membership.new(result.second))
          end

          def test_creates_account_membership
            account = create_account
            attrs = account_membership_attributes

            assert_difference 'Organization::Membership.count', 1 do
              post admin_api.account_memberships_path(account),
                   params: { membership: attrs }
            end
          end

          def test_shows_account_membership
            membership = create_membership

            get admin_api.account_membership_path(membership.account, membership)
            result = JSON.parse(response.body)['membership']
            assert_equal(membership, Organization::Membership.new(result))
          end

          def test_updates_account_membership
            membership = create_membership(role: 'administrator')

            patch admin_api.account_membership_path(membership.account, membership),
                  params: { membership: { role: 'shopper' } }

            membership.reload
            assert_equal('shopper', membership.role)
          end

          def test_destroys_account_memberships
            membership = create_membership

            assert_difference 'Organization::Membership.count', -1 do
              delete admin_api.account_membership_path(membership.account, membership)
            end
          end

          #
          # Unscoped
          #

          def test_bulk_upserts_memberships
            data = Array.new(10) do
              {
                user_id: create_user.id,
                account_id: create_account.id
              }
            end

            assert_difference 'Organization::Membership.count', 10 do
              patch admin_api.bulk_memberships_path,
                    params: { memberships: data }
            end
          end

        end
      end
    end
  end
end
