module Workarea
  module Storefront
    class AccountsController < ApplicationController
      helper Workarea::Storefront::OrganizationsHelper
      include Accounts::RolePermission

      before_action :require_login
      before_action :verify_account
      before_action :require_administrator, only: :update
      before_action :set_account

      def show; end

      def edit; end

      def update
        if @account.update(account_params)

          flash[:success] = t('workarea.storefront.flash_messages.organization_account_updated')
          redirect_to accounts_path
        else
          flash[:error] = t('workarea.storefront.flash_messages.organization_account_error')
          render :edit
        end
      end

      def transactions
        @transactions =
          @account.credit_transactions
                  .order(created_at: :desc)
                  .limit(Workarea.config.account_transaction_count)
      end

      private

      def set_account
        @account = Storefront::AccountViewModel.wrap(
          current_account,
          view_model_options
        )
      end

      def verify_account
        if current_account.nil?
          flash[:error] = t('workarea.storefront.flash_messages.organization_account_permission')
          redirect_back fallback_location: root_path
        end
      end

      def account_params
        params.permit(
          :name,
          :payment_terms,
          :tax_code,
          :credit_limit,
          :require_account_address,
          :require_account_payment,
          :require_order_approval
        )
      end
    end
  end
end
