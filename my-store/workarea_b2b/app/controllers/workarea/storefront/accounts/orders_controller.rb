module Workarea
  module Storefront
    module Accounts
      class OrdersController < ApplicationController
        include RolePermission

        before_action :require_login
        before_action :require_approver, only: :review
        before_action :set_order, except: [:index, :pending]

        def index
          models = Order.recent_for_account(
            current_account.id,
            Workarea.config.storefront_user_order_display_count
          )
          statuses = Fulfillment.find_statuses(*models.map(&:id))

          @orders = models.map do |order|
            Storefront::OrderViewModel.new(
              order,
              fulfillment_status: statuses[order.id]
            )
          end
        end

        def pending
          models = Order.pending_for_account(current_account.id, 999)
          statuses = Fulfillment.find_statuses(*models.map(&:id))

          @orders = models.map do |order|
            Storefront::OrderViewModel.new(
              order,
              fulfillment_status: statuses[order.id]
            )
          end
        end

        def show; end

        def review
          if params[:approve].to_s =~ /true/i
            approve_order
          else
            decline_order
          end

          redirect_back_or accounts_order_path(@order)
        end

        private

        def set_order
          model = Order.find(params[:id])
          @order = Storefront::OrderViewModel.new(model)

          if model.account_id != current_account.id.to_s
            head :forbidden
            return
          end
        end

        def approve_order
          @order.approve!(current_user.id, params[:notes])
          CreateFulfillment.new(@order).perform
          AccountOrderMailer.approved(@order.id).deliver_later
        end

        def decline_order
          @order.decline!(current_user.id, params[:notes])
          CancelOrder.new(
            @order,
            restock: true,
            refund: true,
            fulfillment: true
          ).perform
          AccountOrderMailer.declined(@order.id).deliver_later
        end
      end
    end
  end
end
