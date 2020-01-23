require 'test_helper'

module Workarea
  module Storefront
    class ProductPriceListsSystemTest < Workarea::SystemTest
      def test_showing_price_list_prices
        product = create_product(variants: [{ sku: 'SKU' }])
        category = create_category(product_ids: [product.id])

        Pricing::Sku.find('SKU').update(
          prices: [
            { regular: 5.to_m },
            { regular: 4.to_m, price_list_id: 'foo' }
          ]
        )

        user = create_user(email: 'test@workarea.com', password: 'W3bl1nc!')
        account = create_account(price_list_id: 'foo')
        create_membership(user: user, account: account, role: 'shopper')

        visit storefront.login_path

        within '#login_form' do
          fill_in 'email', with: 'test@workarea.com'
          fill_in 'password', with: 'W3bl1nc!'
          click_button t('workarea.storefront.users.login')
        end

        visit storefront.category_path(category)

        assert(page.has_content?(product.name))
        assert(page.has_content?('$4.00'))
        assert(page.has_content?(t('workarea.storefront.products.retail')))
        assert(page.has_content?('$5.00'))

        click_link product.name, match: :first

        assert(page.has_content?('$4.00'))
        assert(page.has_content?(t('workarea.storefront.products.retail')))
        assert(page.has_content?('$5.00'))

        click_button t('workarea.storefront.products.add_to_cart')
        click_link t('workarea.storefront.carts.view_cart')

        assert(page.has_content?(product.name))
        assert(page.has_content?('$4.00'))
      end
    end
  end
end
