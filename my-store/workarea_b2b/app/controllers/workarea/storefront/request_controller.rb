module Workarea
  module Storefront
    class RequestController < ApplicationController

      def approve
        request = Workarea::Organization::JoinRequest.all.find(params[:button])
        current_user = Workarea::User.all.find(request.user_id)
        current_account = Workarea::Organization::Account.all.find(request.account_id)
        membership = Workarea::Organization::Membership.new(
          user_id: request.user_id,
          user: current_user,
          role: "shopper",
          account: current_account,
          account_id: request.account_id)
        membership.save
        current_account.memberships << membership
        current_account.save
        Workarea::Organization::JoinRequest.all.find(params[:button]).delete
        redirect_back fallback_location: accounts_path
      end

      def reject
        Workarea::Organization::JoinRequest.all.find(params[:button]).delete
        redirect_back fallback_location: accounts_path
      end

    end
  end
end
