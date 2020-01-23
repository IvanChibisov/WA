module Workarea
  module Storefront
    module Accounts
      class AddressesController < ApplicationController
        include RolePermission

        before_action :require_login
        before_action :require_administrator
        before_action :set_address

        def new; end

        def create
          if @address.save
            flash[:success] = t('workarea.storefront.flash_messages.address_saved')
            redirect_to accounts_path
          else
            flash[:error] = t('workarea.storefront.flash_messages.address_save_error')
            render :new
          end
        end

        def edit; end

        def update
          if @address.update(address_params)
            flash[:success] = t('workarea.storefront.flash_messages.address_saved')
            redirect_to accounts_path
          else
            flash[:error] = t('workarea.storefront.flash_messages.address_save_error')
            render :edit
          end
        end

        def destroy
          @address.destroy
          flash[:success] = t('workarea.storefront.flash_messages.address_removed')
          redirect_to accounts_path
        end

        private

        def set_address
          @address ||=
            if params[:id].present?
              current_account.addresses.find(params[:id])
            else
              current_account.addresses.build(address_params)
            end
        end

        def address_params
          params.fetch(:address, {}).permit(*Workarea.config.address_attributes)
        end
      end
    end
  end
end
