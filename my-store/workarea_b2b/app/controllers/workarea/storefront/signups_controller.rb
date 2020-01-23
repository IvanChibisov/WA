module Workarea
  module Storefront
    class SignupsController < ApplicationController
      before_action :find_signup

      def edit; end

      def update
        if @signup.complete(params[:password])
          flash[:success] = t('workarea.storefront.flash_messages.signup_success')
          redirect_to login_path
        else
          flash[:error] = t('workarea.storefront.flash_messages.signup_error')
          render :edit
        end
      end

      private

      def find_signup
        @signup = User::Signup.find_by_token(params[:id]) rescue nil

        if @signup.nil? || @signup.complete?
          flash[:error] = t('workarea.storefront.flash_messages.signup_invalid')
          redirect_to login_path
          false
        end
      end
    end
  end
end
