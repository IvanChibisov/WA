module Workarea
  module Storefront
    class MembershipViewModel < ApplicationViewModel
      include Workarea::MembershipViewModel

      def account
        @account ||= Storefront::AccountViewModel.wrap(account_model, options)
      end

      def user
        @user ||= Storefront::UserViewModel.wrap(user_model, options)
      end
    end
  end
end
