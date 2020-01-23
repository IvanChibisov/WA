module Workarea
  module Admin
    class MembershipViewModel < ApplicationViewModel
      include Workarea::MembershipViewModel

      def user
        @user ||= Admin::UserViewModel.wrap(user_model, options)
      end

      def account
        @account ||= Admin::AccountViewModel.wrap(account_model, options)
      end
    end
  end
end
