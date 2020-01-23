require 'test_helper'

module Workarea
  if Plugin.installed?('Workarea::Api::Admin')
    module Api
      module Admin
        class AccountsIntegrationTest < IntegrationTest
          include Workarea::Admin::IntegrationTest

          setup :set_sample_attributes

          def set_sample_attributes
            @sample_attributes = create_account.as_json.except('_id')
          end

          def test_lists_accounts
            accounts = [create_account, create_account]
            get admin_api.accounts_path
            result = JSON.parse(response.body)['accounts']

            assert_equal(3, result.length)
            assert_equal(accounts.second, Organization::Account.new(result.first))
            assert_equal(accounts.first, Organization::Account.new(result.second))
          end

          def test_creates_accounts
            assert_difference 'Organization::Account.count', 1 do
              post admin_api.accounts_path,
                   params: { account: @sample_attributes }
            end
          end

          def test_shows_accounts
            account = create_account
            get admin_api.account_path(account.id)
            result = JSON.parse(response.body)['account']
            assert_equal(account, Organization::Account.new(result))
          end

          def test_updates_accounts
            account = create_account
            patch admin_api.account_path(account.id),
                  params: { account: { name: 'foo' } }

            account.reload
            assert_equal('foo', account.name)
          end

          def test_bulk_upserts_accounts
            data = [@sample_attributes] * 10

            assert_difference 'Organization::Account.count', 10 do
              patch admin_api.bulk_accounts_path,
                    params: { accounts: data }
            end
          end

          def test_destroys_accounts
            account = create_account

            assert_difference 'Organization::Account.count', -1 do
              delete admin_api.account_path(account.id)
            end
          end
        end
      end
    end
  end
end
