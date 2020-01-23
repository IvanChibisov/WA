module Workarea
  module Storefront
    class AccountOrderMailer < Storefront::ApplicationMailer
      def pending(order_id)
        order = Order.find(order_id)
        return unless order.account_id.present?

        @order = Storefront::OrderViewModel.new(order)
        @account = Organization::Account.find(order.account_id)
        recipients =
          @account.memberships.approvers.includes(:user).map(&:user).map(&:email) - [order.email]

        return unless recipients.present?
        mail(
          to: recipients,
          subject: t(
            'workarea.storefront.email.account_order_pending.subject',
            order_id: @order.id,
            account: @account.name
          )
        )
      end

      def placed(order_id)
        order = Order.find(order_id)
        return unless order.account_id.present?

        @order = Storefront::OrderViewModel.new(order)
        @account = Organization::Account.find(order.account_id)
        recipients =
          @account.memberships.administrators.includes(:user).map(&:user).map(&:email) - [order.email]

        return unless recipients.present?
        mail(
          to: recipients,
          subject: t(
            'workarea.storefront.email.account_order_placed.subject',
            order_id: @order.id,
            account: @account.name
          )
        )
      end

      def approved(order_id)
        order = Order.find(order_id)
        @order = Storefront::OrderViewModel.new(order)
        @account = Organization::Account.find(order.account_id)

        mail(
          to: order.email,
          subject: t(
            'workarea.storefront.email.account_order_approved.subject',
            order_id: @order.id
          )
        )
      end

      def declined(order_id)
        order = Order.find(order_id)
        @order = Storefront::OrderViewModel.new(order)
        @account = Organization::Account.find(order.account_id)

        mail(
          to: order.email,
          subject: t(
            'workarea.storefront.email.account_order_declined.subject',
            order_id: @order.id
          )
        )
      end
    end
  end
end
