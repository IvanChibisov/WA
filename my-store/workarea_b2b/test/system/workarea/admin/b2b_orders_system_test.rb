require 'test_helper'

module Workarea
  module Admin
    class B2bOrdersSystemTest < Workarea::SystemTest
      include Admin::IntegrationTest

      def test_viewing_order_with_terms
        order = create_placed_order
        payment = Payment.find(order.id)

        payment.build_terms(amount: 1.to_m, purchase_order_number: 'PO123')
        payment.save

        visit admin.order_path(order)

        assert(page.has_content?(t('workarea.admin.orders.tenders.terms')))
        assert(page.has_content?('PO123'))
      end
    end
  end
end
