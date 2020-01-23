require 'test_helper'

module Workarea
  module Storefront
    module Accounts
      class AddressesIntegrationTest < Workarea::IntegrationTest
        setup :set_membership

        def set_membership
          @user = create_user(email: 'bcrouse@workarea.com', password: 'W3bl1nc!')
          @account = create_account
          @membership = create_membership(user: @user, account: @account, role: 'administrator')

          set_current_user(@user)
        end

        def test_create
          post storefront.accounts_addresses_path,
               params: {
                 address: {
                   first_name: 'Ben',
                   last_name: 'Crouse',
                   street: '12 N. 3rd St.',
                   city: 'Philadelphia',
                   region: 'PA',
                   country: 'US',
                   postal_code: '19106',
                   phone_number: '2159251800'
                 }
               }

          assert_redirected_to(storefront.accounts_path)

          @account.reload
          assert_equal(1, @account.addresses.length)

          address = @account.addresses.first
          assert_equal('Ben', address.first_name)
          assert_equal('Crouse', address.last_name)
          assert_equal('12 N. 3rd St.', address.street)
          assert_equal('Philadelphia', address.city)
          assert_equal('PA', address.region)
          assert_equal(Country['US'], address.country)
          assert_equal('19106', address.postal_code)
          assert_equal('2159251800', address.phone_number)
        end

        def test_update
          address = @account.addresses.create!(
            first_name: 'Ben',
            last_name: 'Crouse',
            street: '22 S. 3rd St.',
            city: 'Philadelphia',
            region: 'PA',
            postal_code: '19106',
            country: 'US',
            phone_number: '2159251800'
          )

          patch storefront.accounts_address_path(address),
                params: {
                  address: {
                    first_name: 'Ben',
                    last_name: 'Crouse',
                    street: '12 N. 3rd St.',
                    street_2: 'Second Floor',
                    city: 'Philadelphia',
                    region: 'PA',
                    postal_code: '19106',
                    country: 'US',
                    phone_number: '2159251800'
                  }
                }

          assert_redirected_to(storefront.accounts_path)

          address.reload
          assert_equal('12 N. 3rd St.', address.street)
          assert_equal('Second Floor', address.street_2)
        end

        def test_destroy
          address = @account.addresses.create!(
            first_name: 'Ben',
            last_name: 'Crouse',
            street: '22 S. 3rd St.',
            city: 'Philadelphia',
            region: 'PA',
            postal_code: '19106',
            country: 'US',
            phone_number: '2159251800'
          )

          delete storefront.accounts_address_path(address)

          assert_redirected_to(storefront.accounts_path)

          @account.reload
          assert(@account.addresses.empty?)
        end

        def test_requires_administator
          @membership.update(role: 'approver')

          post storefront.accounts_addresses_path,
               params: {
                 address: {
                   first_name: 'Ben',
                   last_name: 'Crouse',
                   street: '12 N. 3rd St.',
                   city: 'Philadelphia',
                   region: 'PA',
                   country: 'US',
                   postal_code: '19106',
                   phone_number: '2159251800'
                 }
               }

          assert_redirected_to(storefront.accounts_path)
          assert(flash[:info].present?)
          assert(@account.reload.addresses.empty?)
        end
      end
    end
  end
end
