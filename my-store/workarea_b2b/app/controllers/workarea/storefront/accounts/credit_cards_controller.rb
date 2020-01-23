module Workarea
  module Storefront
    module Accounts
      class CreditCardsController < ApplicationController
        include RolePermission

        before_action :require_login
        before_action :require_administrator
        before_action :set_credit_card

        def new
          @profile = Payment::Profile.lookup(PaymentReference.new(current_account))
        end

        def create
          if @credit_card.save
            flash[:success] = t('workarea.storefront.flash_messages.credit_card_saved')
            redirect_to accounts_path
          else
            flash[:error] = t('workarea.storefront.flash_messages.credit_card_save_error')
            render :new
          end
        end

        def edit; end

        def update
          if @credit_card.update(credit_card_params)
            flash[:success] = t('workarea.storefront.flash_messages.credit_card_updated')
            redirect_to accounts_path
          else
            flash[:error] = t('workarea.storefront.flash_messages.credit_card_update_error')
            render :edit
          end
        end

        def destroy
          @credit_card.destroy
          flash[:success] = t('workarea.storefront.flash_messages.credit_card_removed')
          redirect_to accounts_path
        end

        private

        def set_credit_card
          @credit_card =
            if params[:id].present?
              current_profile.credit_cards.find(params[:id])
            else
              current_profile.credit_cards.build(credit_card_params)
            end
        end

        def current_profile
          @current_profile ||= Payment::Profile.lookup(
            PaymentReference.new(current_account)
          )
        end

        def credit_card_params
          params.fetch(:credit_card, {})
                .permit(:first_name, :last_name, :number, :month, :year, :cvv, :default)
        end
      end
    end
  end
end
