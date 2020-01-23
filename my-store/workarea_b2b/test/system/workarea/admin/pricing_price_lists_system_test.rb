require 'test_helper'

module Workarea
  module Admin
    class PricingPriceListsSystemTest < Workarea::SystemTest
      include Admin::IntegrationTest

      def test_managing_pricing_price_lists
        visit admin.pricing_price_lists_path

        click_link 'add_price_list'

        fill_in 'price_list[id]', with: 'foo_bar'
        fill_in 'price_list[name]', with: 'Foo List'
        click_button 'create_price_list'

        assert(page.has_content?('Success'))
        assert(page.has_content?('foo_bar'))
        assert(page.has_content?('Foo List'))

        click_link t('workarea.admin.actions.delete')

        assert(page.has_content?('Success'))
        assert(page.has_no_content?('foo_bar'))
        assert(page.has_no_content?('Foo List'))
      end

      def test_setting_price_list_on_prices
        price_list = create_price_list(id: 'foo', name: 'Foo List')

        sku = create_pricing_sku(
          prices: [
            { regular: 11, sale: 9.99, min_quantity: 1 },
            { regular: 5, sale: 3, min_quantity: 7 }
          ])

        visit admin.pricing_sku_prices_path(sku)
        click_link t('workarea.admin.prices.index.button')
        fill_in 'price[regular]', with: '10.00'
        fill_in 'price[min_quantity]', with: '2'
        select 'Foo List', from: 'price[price_list_id]'

        click_button t('workarea.admin.prices.new.create_price')
        assert(page.has_content?('Success'))

        row = find_all("table tr")[3]
        within(row) do
          assert(has_content?('$10.00'))
          assert(has_content?('2'))
          assert(has_content?('Foo List'))
        end

        click_on(t('workarea.admin.actions.edit'), match: :first)

        select 'Foo List', from: 'price[price_list_id]'
        click_button t('workarea.admin.form.save_changes')

        assert(page.has_content?('Success'))

        row = find_all("table tr")[1]
        within(row) do
          assert(has_content?('Foo List'))
        end

        click_on(t('workarea.admin.actions.edit'), match: :first)

        select 'none', from: 'price[price_list_id]'
        click_button t('workarea.admin.form.save_changes')

        assert(page.has_content?('Success'))

        row = find_all("table tr")[1]
        within(row) do
          assert(has_content?('-'))
          assert(has_no_content?('Foo List'))
        end
      end

      def test_viewing_price_list_associations
        price_list = create_price_list(id: 'foo', name: 'Foo List')
        sku = create_pricing_sku(
          id: '123-789',
          prices: [
            { regular: 6, min_quantity: 1 },
            { regular: 5, min_quantity: 1, price_list_id: 'foo' }
          ])
        account = create_account(name: 'Bar Account', price_list_id: 'foo')

        visit admin.pricing_price_list_path(price_list)

        assert(page.has_content?(sku.id))
        assert(page.has_content?(account.name))

        click_link t('workarea.admin.pricing_price_lists.cards.accounts.title')

        assert(page.has_content?(account.name))
        assert(page.has_content?(account.organization.name))

        click_link price_list.name
        assert(page.has_content?(sku.id))

        click_link t('workarea.admin.pricing_price_lists.cards.pricing.title')

        assert(page.has_content?(sku.id))
        assert(page.has_content?('$6.00'))
        assert(page.has_content?('$5.00'))
      end
    end
  end
end
