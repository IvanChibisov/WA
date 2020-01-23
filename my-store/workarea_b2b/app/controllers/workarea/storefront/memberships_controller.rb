module Workarea
  module Storefront
    class MembershipsController < ApplicationController
      def update
        membership = Organization::Membership.find(params[:membership_id])

        if membership.user_id.to_s == current_user.id.to_s
          self.current_membership = membership
          flash[:success] = t(
            'workarea.storefront.flash_messages.account_switched',
            account: current_membership.account_name
          )
        else
          flash[:error] = t('workarea.storefront.flash_messages.account_switch_failed')
        end

        redirect_back fallback_location: accounts_path
      end
    end
  end
end
