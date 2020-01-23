require 'test_helper'

module Workarea
  module Admin
    class OrganizationAccountsSystemTest < Workarea::SystemTest
      include Admin::IntegrationTest

      setup :configure_payment_terms
      teardown :reset_payment_terms

      def configure_payment_terms
        @terms = Workarea.config.payment_terms
        Workarea.config.payment_terms = { '001' => [], '002' => [] }
      end

      def reset_payment_terms
        Workarea.config.payment_terms = @terms
      end

      def test_managing_accounts
        organization = create_organization(name: 'Foo Org')
        price_list = create_price_list(name: 'Bar List')
        price_list_two = create_price_list(name: 'VIP List')

        visit admin.organization_accounts_path

        click_link 'add_account'

        find('#select2-account_organization_id-container').click
        assert(page.has_content?('Foo Org'))
        find('.select2-results__option', text: 'Foo Org').click

        fill_in 'account[name]', with: 'The Bar Account'
        fill_in 'account[credit_limit]', with: '1200.00'
        select '002', from: 'account[payment_terms]'

        find('#select2-account_price_list_id-container').click
        assert(page.has_content?('Bar List'))
        find('.select2-results__option', text: 'Bar List').click

        click_button 'create_account'

        assert(page.has_content?('Success'))

        assert(page.has_content?('The Bar Account'))
        assert(page.has_content?('Foo Org'))
        assert(page.has_content?('$1,200.00'))
        assert(page.has_content?('002'))
        assert(page.has_content?('Bar List'))

        visit admin.organization_accounts_path

        assert(page.has_content?('The Bar Account'))
        assert(page.has_content?('Foo Org'))
        assert(page.has_content?('$1,200.00'))

        account = Organization::Account.last
        account.update(
          addresses: [{
            first_name: 'Ben',
            last_name: 'Crouse',
            street: '22 S. 3rd St.',
            street_2: 'Second Floor',
            city: 'Philadelphia',
            region: 'PA',
            postal_code: '19106',
            country: 'US'
          }]
        )
        create_membership(
          account: account,
          user: create_user(first_name: 'Bob', last_name: 'Clams'),
          role: 'approver'
        )

        click_link 'The Bar Account'

        assert(page.has_content?('Bob Clams approver'))
        assert(page.has_content?('Ben Crouse'))
        assert(page.has_content?('22 S. 3rd St.'))

        click_link t('workarea.admin.organization_accounts.cards.memberships.title')

        assert(page.has_content?('Bob Clams'))
        assert(page.has_content?('Approver'))
        assert(page.has_content?('No'))

        click_link 'The Bar Account'

        click_link t('workarea.admin.organization_accounts.cards.addresses.title')

        assert(page.has_content?('Ben Crouse'))
        assert(page.has_content?('22 S. 3rd St.'))
        assert(page.has_content?('Philadelphia PA 19106'))

        click_link 'The Bar Account'
        click_link 'Attributes'

        fill_in 'account[name]', with: 'Foobar Account'
        select '001', from: 'account[payment_terms]'
        find('#select2-account_price_list_id-container').click
        assert(page.has_content?('VIP List'))
        find('.select2-results__option', text: 'VIP List').click

        click_button 'save_account'

        assert(page.has_content?('Success'))

        assert(page.has_content?('Foobar Account'))
        assert(page.has_content?('Foo Org'))
        assert(page.has_content?('$1,200.00'))
        assert(page.has_content?('001'))
        assert(page.has_content?('VIP List'))
      end

      def test_managing_account_credit
        account = create_account(credit_limit: 200.to_m, balance: 175.to_m)

        visit admin.organization_account_path(account)

        assert(page.has_content?('$200.00'))
        assert(page.has_content?('$175.00'))

        click_link t('workarea.admin.organization_accounts.cards.credit.title')

        fill_in 'account[credit_limit]', with: '350'
        click_button t('workarea.admin.organization_accounts.credit.update')

        assert(page.has_content?('Success'))
        assert(page.has_content?('$350.00'))

        click_link t('workarea.admin.organization_accounts.cards.credit.title')

        fill_in 'amount', with: '80'
        click_button t('workarea.admin.organization_accounts.credit.reimburse')

        assert(page.has_content?('Success'))
        assert(page.has_content?('$95.00'))

        click_link t('workarea.admin.organization_accounts.cards.credit.title')

        assert(page.has_content?('$80.00'))
        assert(
          page.has_content?(
            t('workarea.organization_credit_transaction.reimbursement').titleize
          )
        )
      end

      def test_account_and_organization_creation
        visit admin.organization_accounts_path

        click_link 'add_account'

        fill_in 'organization_name', with: 'Foo Org'
        fill_in 'account[name]', with: 'The Bar Account'

        click_button 'create_account'

        assert(page.has_content?('Success'))

        assert(page.has_content?('The Bar Account'))
        assert(page.has_content?('Foo Org'))
      end
    end
  end
end
