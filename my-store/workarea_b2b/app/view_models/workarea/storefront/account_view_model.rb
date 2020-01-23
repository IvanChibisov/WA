module Workarea
  module Storefront
    class AccountViewModel < ApplicationViewModel
      delegate :credit_cards, :default_credit_card, to: :payment_profile

      def payment_profile
        @payment_profile ||= Payment::Profile.lookup(PaymentReference.new(model))
      end

      def has_default_addresses?
        addresses.present?
      end

      def addresses?
        addresses.present?
      end

      def payments?
        credit_cards.present? || allows_terms?
      end

      def require_account_address?
        addresses? && model.require_account_address?
      end

      def require_account_payment?
        payments? && model.require_account_payment?
      end

      def has_credit_card?
        !!default_credit_card
      end

      def recent_orders
        @recent_orders ||= begin
          models = Order.recent_for_account(model.id, order_limit)
          statuses = Fulfillment.find_statuses(*models.map(&:id))

          models.map do |order|
            Storefront::OrderViewModel.new(
              order,
              fulfillment_status: statuses[order.id]
            )
          end
        end
      end

      def pending_orders
        @pending_orders ||= begin
          models = Order.pending_for_account(model.id, order_limit)
          statuses = Fulfillment.find_statuses(*models.map(&:id))

          PagedArray.from(
            models.map do |order|
              Storefront::OrderViewModel.new(
                order,
                fulfillment_status: statuses[order.id]
              )
            end,
            1,
            order_limit,
            models.count
          )
        end
      end

      def memberships
        @memberships ||= Storefront::MembershipViewModel.wrap(
          model.memberships,
          options.merge(user: nil, account: self)
        )
      end

      def price_list
        return unless price_list_id.present?
        @price_list ||= Pricing::PriceList.find(price_list_id)
      rescue Mongoid::Errors::DocumentNotFound
        @price_list = nil
      end

      private

      def order_limit
        Workarea.config.recent_order_count
      end
    end
  end
end
