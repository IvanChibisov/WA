require 'test_helper'

module Workarea
  module Storefront
    class B2bOrdersSystemTest < Workarea::SystemTest
      def test_reordering_from_detail_page
        user = create_user(email: 'bcrouse@workarea.com', password: 'W3bl1nc!')
        create_placed_order(user_id: user.id)

        visit storefront.login_path

        within '#login_form' do
          fill_in 'email', with: 'bcrouse@workarea.com'
          fill_in 'password', with: 'W3bl1nc!'
          click_button t('workarea.storefront.users.login')
        end

        visit storefront.users_account_path

        click_link t('workarea.storefront.orders.view'), match: :first
        click_link t('workarea.storefront.orders.reorder')

        assert_current_path(storefront.cart_path)
        assert(page.has_content?('Success'))
        assert(page.has_content?('Test Product'))
        assert(page.has_content?('SKU'))
        assert(page.has_content?('$10.00'))
      end
    end
  end
end
