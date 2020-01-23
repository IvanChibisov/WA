module Workarea
  module Admin
    class OrganizationMembershipsController < Admin::ApplicationController
      required_permissions :people

      before_action :find_or_create_user, only: :create
      before_action :find_membership

      def create
        if @membership.save
          flash[:success] = t('workarea.admin.organization_memberships.flash_messages.created')
        else
          flash[:error] = t('workarea.admin.organization_memberships.flash_messages.error')
        end

        redirect_back_or memberships_organization_account_path(@membership.account)
      end

      def update
        if @membership.update(membership_params)
          flash[:success] = t('workarea.admin.organization_memberships.flash_messages.updated')
        else
          flash[:error] = t('workarea.admin.organization_memberships.flash_messages.error')
        end

        redirect_back_or memberships_organization_account_path(@membership.account)
      end

      def destroy
        account = @membership.account

        @membership.destroy
        flash[:success] = t('workarea.admin.organization_memberships.flash_messages.destroyed')
        redirect_back_or memberships_organization_account_path(account)
      end

      private

      def find_membership
        model =
          if params[:id].present?
            Organization::Membership.find(params[:id])
          else
            Organization::Membership.new(membership_params)
          end

        @membership = Admin::MembershipViewModel.wrap(
          model,
          view_model_options.merge(user: @user)
        )
      end

      def find_or_create_user
        @user = User.find(params[:user_id]) rescue nil
        return if @user.present? || params[:email].blank?

        @user = User.find_or_initialize_by(email: params[:email])
        return if @user.persisted?

        @user.update(password: "#{SecureRandom.base58}B2b!")
        User::Signup.create(user: @user)
      end

      def membership_params
        params.fetch(:membership, {})
              .slice(:role, :account_id, :default)
              .merge(user_id: @user&.id)
              .reject { |_, v| v.blank? }
      end
    end
  end
end
