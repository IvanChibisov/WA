require 'test_helper'

module Workarea
  module Admin
    class OrganizationAccountsIntegrationTest < Workarea::IntegrationTest
      include Admin::IntegrationTest

      def test_create
        organization = create_organization

        post admin.organization_accounts_path,
             params: {
               account: {
                 organization_id: organization.id,
                 name: 'Foo Account',
               }
             }

        account = Organization::Account.last
        assert_redirected_to(admin.organization_account_path(account))
        assert(flash[:success].present?)
        assert_equal('Foo Account', account.name)
        assert_equal(organization, account.organization)
      end

      def test_create_with_new_organization
        post admin.organization_accounts_path,
             params: {
               organization_name: 'Test Org',
               account: {
                 name: 'Foo Account',
               }
             }

        account = Organization::Account.last
        assert_redirected_to(admin.organization_account_path(account))
        assert(flash[:success].present?)
        assert_equal('Foo Account', account.name)
        assert_equal('Test Org', account.organization.name)
      end

      def test_update
        account = create_account

        put admin.organization_account_path(account),
            params: {
              account: {
                name: 'Foo Account',
                credit_limit: '2500'
              }
            }

        account.reload
        assert_redirected_to(admin.organization_account_path(account))
        assert(flash[:success].present?)
        assert_equal('Foo Account', account.name)
        assert_equal(2500.to_m, account.credit_limit)
      end

      def test_destroy
        account = create_account

        delete admin.organization_account_path(account)

        assert_equal(0, Organization::Account.count)
        assert_redirected_to(admin.organization_accounts_path)
        assert(flash[:success].present?)
      end

      def test_reimburse
        account = create_account(credit_limit: 100.to_m, balance: 50.to_m)

        put admin.reimburse_organization_account_path(account),
            params: { amount: '25.00' }

        account.reload
        assert_redirected_to(admin.organization_account_path(account))
        assert(flash[:success].present?)
        assert_equal(25.to_m, account.balance)
        assert_equal(25.to_m, account.credit_transactions.first.amount)
        assert_equal(
          t('workarea.organization_credit_transaction.reimbursement'),
          account.credit_transactions.first.action
        )
      end
    end
  end
end
