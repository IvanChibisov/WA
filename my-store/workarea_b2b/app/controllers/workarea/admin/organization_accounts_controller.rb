module Workarea
  module Admin
    class OrganizationAccountsController < Admin::ApplicationController
      required_permissions :people

      before_action :find_account, except: :index

      def index
        search = Search::AdminAccounts.new(
          params.merge(autocomplete: request.xhr?)
        )

        @search = Admin::SearchViewModel.new(search, view_model_options)
      end

      def show; end

      def new; end

      def create
        create_and_set_organization

        if @account.save
          flash['success'] = t('workarea.admin.organization_accounts.flash_messages.created')
          redirect_to organization_account_path(@account)
        else
          flash['error'] = t('workarea.admin.organization_accounts.flash_messages.error')
          render :new
        end
      end

      def edit; end

      def update
        if @account.update(account_params)
          flash['success'] = t('workarea.admin.organization_accounts.flash_messages.updated')
          redirect_to organization_account_path(@account)
        else
          flash['error'] = 'There were errors updating your account'
          render :edit
        end
      end

      def destroy
        @account.destroy

        flash['success'] = t('workarea.admin.organization_accounts.flash_messages.destroyed')
        redirect_to organization_accounts_path
      end

      def addresses; end

      def memberships; end

      def credit
        @transactions =
          @account.credit_transactions
                  .order(created_at: :desc)
                  .page(params[:page])
                  .per(Workarea.config.per_page)
      end

      def reimburse
        amount = [params[:amount].to_m, @account.balance].min
        @account.reimburse!(amount)

        flash[:success] = t('workarea.admin.organization_accounts.flash_messages.reimbursed')
        redirect_to organization_account_path(@account)
      end

      private

      def find_account
        model =
          if params[:id].present?
            Organization::Account.find(params[:id])
          else
            Organization::Account.new(account_params)
          end

        @account = Admin::AccountViewModel.wrap(model, view_model_options)
      end

      def account_params
        params.fetch(:account, {})
      end

      def create_and_set_organization
        return unless params[:organization_name].present?

        organization = Organization.create!(name: params[:organization_name])
        @account.organization_id = organization.id
      end
    end
  end
end
