require 'test_helper'

module Workarea
  module Admin
    class PricingPriceListsIntegrationTest < Workarea::IntegrationTest
      include Admin::IntegrationTest

      def test_create
        post admin.pricing_price_lists_path,
             params: {
               price_list: {
                 id: 'FOO_BAR',
                 name: 'Foo List'
               }
             }


        price_list = Pricing::PriceList.last
        assert_redirected_to(admin.pricing_price_list_path(price_list))
        assert(flash[:success].present?)
        assert_equal('FOO_BAR', price_list.id)
        assert_equal('Foo List', price_list.name)
      end

      def test_create_without_id
        post admin.pricing_price_lists_path,
             params: {
               price_list: {
                 id: '',
                 name: 'Foo List'
               }
             }

        price_list = Pricing::PriceList.last
        assert_redirected_to(admin.pricing_price_list_path(price_list))
        assert(flash[:success].present?)
        assert(price_list.id.present?)
        assert_equal('Foo List', price_list.name)
      end

      def test_destroy
        price_list = create_price_list

        delete admin.pricing_price_list_path(price_list)

        assert_equal(0, Pricing::PriceList.count)
        assert_redirected_to(admin.pricing_price_lists_path)
        assert(flash[:success].present?)
      end
    end
  end
end
