require 'test_helper'

module Workarea
  if Plugin.installed?('Workarea::Api::Admin')
    module Api
      module Admin
        class PriceListsIntegrationTest < IntegrationTest
          include Workarea::Admin::IntegrationTest

          setup :set_sample_attributes

          def set_sample_attributes
            @sample_attributes = create_price_list.as_json.except('_id')
          end

          def test_lists_price_lists
            price_lists = [create_price_list, create_price_list]
            get admin_api.price_lists_path
            result = JSON.parse(response.body)['price_lists']

            assert_equal(3, result.length)
            assert_equal(price_lists.second, Pricing::PriceList.new(result.first))
            assert_equal(price_lists.first, Pricing::PriceList.new(result.second))
          end

          def test_creates_price_lists
            assert_difference 'Pricing::PriceList.count', 1 do
              post admin_api.price_lists_path,
                   params: { price_list: @sample_attributes }
            end
          end

          def test_shows_price_lists
            price_list = create_price_list
            get admin_api.price_list_path(price_list.id)
            result = JSON.parse(response.body)['price_list']
            assert_equal(price_list, Pricing::PriceList.new(result))
          end

          def test_updates_price_lists
            price_list = create_price_list
            patch admin_api.price_list_path(price_list.id),
                  params: { price_list: { name: 'foo' } }

            price_list.reload
            assert_equal('foo', price_list.name)
          end

          def test_bulk_upserts_price_lists
            data = [@sample_attributes] * 10

            assert_difference 'Pricing::PriceList.count', 10 do
              patch admin_api.bulk_price_lists_path,
                    params: { price_lists: data }
            end
          end

          def test_destroys_price_lists
            price_list = create_price_list

            assert_difference 'Pricing::PriceList.count', -1 do
              delete admin_api.price_list_path(price_list.id)
            end
          end
        end
      end
    end
  end
end
