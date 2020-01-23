module Workarea
  module Storefront
    class MembershipAccountController < ApplicationController

      def show; end

      def user_params
        params.permit(
          :email,
          :first_name,
          :last_name
        )
      end

      def edit
        @user = Storefront::EditMembershipViewModel.new(current_user)
      end

      def update
        if current_user.update_attributes(user_params)
          flash[:success] = t('workarea.storefront.flash_messages.account_updated')
          redirect_to accounts_path
        else
          flash[:error] = current_user.errors.to_a.to_sentence
          current_user.reload
          @user = Storefront::UserViewModel.new(current_user)
          find_recommendations
          render :show
        end
      end

    end
  end
end
