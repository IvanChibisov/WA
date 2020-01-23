require 'test_helper'

module Workarea
  class Checkout
    module Steps
      class B2bPaymentTest < TestCase
        setup :set_shipping_service, :set_product, :set_addresses

        def set_shipping_service
          create_shipping_service(
            name: 'Test',
            rates: [{ price: 5.to_m }],
            tax_code: '001'
          )
        end

        def set_product
          create_product(id: 'PROD')
        end

        def set_addresses
          address_params = {
            first_name:   'Ben',
            last_name:    'Crouse',
            street:       '22 S. 3rd St.',
            city:         'Philadelphia',
            region:       'PA',
            postal_code:  '19106',
            country:      'US',
            phone_number: '2159251800'
          }

          Addresses.new(checkout).update(
            shipping_address: address_params,
            billing_address: address_params
          )
        end

        def order
          @order ||= create_order(
            email: 'test@workarea.com',
            items: [{ product_id: 'PROD', sku: 'SKU' }]
          )
        end

        def checkout
          @checkout ||= Checkout.new(order, create_user)
        end

        def test_update
          Workarea.with_config do |config|
            config.payment_terms = {
              'Credit card or terms' => %i(credit_card terms),
            }

            step = Checkout::Steps::Payment.new(checkout)
            assert(step.update(payment: 'terms'))
            assert(checkout.payment.terms.nil?)

            Current.account = Storefront::AccountViewModel.wrap(
              create_account(payment_terms: 'Credit card or terms')
            )

            step = Checkout::Steps::Payment.new(checkout)
            params = {
              payment: 'terms',
              terms: { purchase_order_number: '123' }
            }
            assert(step.update(params))

            assert(checkout.payment.terms.present?)
            assert(checkout.payment.terms.amount)
            assert_equal('123', checkout.payment.terms.purchase_order_number)
            assert(checkout.payment.account_profile.present?)

            step = Checkout::Steps::Payment.new(checkout)
            step.update
            assert(checkout.payment.terms.nil?)
          end
        end
      end
    end
  end
end
