require 'test_helper'

module Workarea
  module Admin
    class OrganizationMembershipsSystemTest < Workarea::SystemTest
      include Admin::IntegrationTest

      def test_managing_memberships_from_user
        user = create_user
        organization = create_organization(name: 'Lorem Ipsum')
        account = create_account(name: 'Foo', organization: organization)

        create_membership(user: user, account: account, role: 'shopper')
        create_account(name: 'Bar')

        visit admin.user_path(user)

        assert(page.has_content?(t('workarea.admin.users.cards.memberships.title')))
        assert(page.has_content?('Lorem Ipsum Foo shopper'))

        click_link t('workarea.admin.users.cards.memberships.title')

        assert(page.has_content?('Foo'))
        assert(page.has_content?('Lorem Ipsum'))
        assert(page.has_content?('Shopper'))
        assert(page.has_content?('No'))

        click_link t('workarea.admin.actions.delete')

        assert_current_path(admin.memberships_user_path(user))
        assert(page.has_content?('Success'))
        assert(page.has_no_content?('Lorem Ipsum'))
        assert(page.has_no_content?('Foo'))
        assert(page.has_no_content?('Shopper'))

        click_button 'add_membership'

        find('#select2-membership_account_id-container').click
        assert(page.has_content?('Bar'))
        find('.select2-results__option', text: 'Bar').click

        select 'Approver', from: 'membership[role]'
        click_button 'create_membership'

        assert_current_path(admin.memberships_user_path(user))
        assert(page.has_content?('Success'))
        assert(page.has_content?('Test Organization'))
        assert(page.has_content?('Bar'))
        assert(page.has_content?('Approver'))

        click_link t('workarea.admin.actions.edit')
        select 'Administrator', from: 'membership[role]'
        click_button 'save_membership'

        assert_current_path(admin.memberships_user_path(user))
        assert(page.has_content?('Success'))
        assert(page.has_content?('Administrator'))
      end

      def test_managing_memberships_from_account
        user = create_user(first_name: 'Bob', last_name: 'Clamsy')
        organization = create_organization(name: 'Lorem Ipsum')
        account = create_account(name: 'Foo', organization: organization)

        create_membership(user: user, account: account, role: 'shopper')

        visit admin.organization_account_path(account)

        assert(page.has_content?(t('workarea.admin.organization_accounts.cards.memberships.title')))
        assert(page.has_content?('Bob Clamsy shopper'))

        click_link t('workarea.admin.organization_accounts.cards.memberships.title')

        assert(page.has_content?('Bob Clamsy'))
        assert(page.has_content?('Shopper'))
        assert(page.has_content?('No'))

        click_link t('workarea.admin.actions.delete')

        assert_current_path(admin.memberships_organization_account_path(account))
        assert(page.has_content?('Success'))
        assert(page.has_no_content?('Bob Clamsy'))
        assert(page.has_no_content?('Shopper'))

        click_button 'add_membership'

        fill_in 'email', with: 'testing@workarea.com'

        select 'Approver', from: 'membership[role]'
        click_button 'create_membership'

        assert_current_path(admin.memberships_organization_account_path(account))
        assert(page.has_content?('Success'))
        assert(page.has_content?('testing@workarea.com'))
        assert(page.has_content?('Approver'))

        click_link t('workarea.admin.actions.edit')
        select 'Administrator', from: 'membership[role]'
        click_button 'save_membership'

        assert_current_path(admin.memberships_organization_account_path(account))
        assert(page.has_content?('Success'))
        assert(page.has_content?('Administrator'))
      end
    end
  end
end
