module Workarea
  module Admin
    class AccountViewModel < ApplicationViewModel
      include CommentableViewModel

      delegate :name, to: :price_list, prefix: true, allow_nil: true

      def organization
        @organization ||= Admin::OrganizationViewModel.wrap(
          model.organization,
          options
        )
      end

      def orders
        @orders ||= Admin::OrderViewModel.wrap(
          Order.placed.for_account(id.to_s),
          options
        )
      end

      def orders_count
        @orders_count ||= Order.placed.for_account(id.to_s).count
      end

      def memberships
        @memberships ||= Admin::MembershipViewModel.wrap(
          model.memberships.includes(:user),
          options.merge(account: model)
        )
      end

      def price_list
        return unless price_list_id.present?
        @price_list ||= Pricing::PriceList.find(price_list_id)
      rescue Mongoid::Errors::DocumentNotFound
        @price_list = nil
      end

      def timeline
        @timeline ||= TimelineViewModel.new(model)
      end
    end
  end
end
