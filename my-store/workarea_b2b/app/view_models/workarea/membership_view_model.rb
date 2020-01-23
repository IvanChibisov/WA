module Workarea
  module MembershipViewModel
    extend ActiveSupport::Concern

    def user_model
      @user_model ||= options[:user] || model.user
    end

    def account_model
      @account_model ||= options[:account] || model.account
    end
  end
end
