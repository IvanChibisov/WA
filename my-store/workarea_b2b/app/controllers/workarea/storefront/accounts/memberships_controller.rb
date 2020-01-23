module Workarea
  module Storefront
    module Accounts
      class MembershipsController < ApplicationController
        include RolePermission

        before_action :require_login
        before_action :require_administrator
        before_action :set_membership, except: :index

        def index
        end

        def new; end

        def create
          @membership.user_id = find_or_create_user.id

          if @membership.save
            flash[:success] = t('workarea.storefront.flash_messages.membership_created')
            redirect_back fallback_location: accounts_path
          else
            flash[:error] = t('workarea.storefront.flash_messages.membership_error')
            render :new
          end
        end

        def reject(request)
        end

        def approve(request)
        end

        def edit; end

        def update
          if @membership.update(membership_params)
            flash[:success] = t('workarea.storefront.flash_messages.membership_updated')
            redirect_back fallback_location: accounts_path
          else
            flash[:error] = t('workarea.storefront.flash_messages.membership_error')
            render :edit
          end
        end

        def destroy
          @membership.destroy
          flash[:success] = t('workarea.storefront.flash_messages.membership_destroyed')
          redirect_back fallback_location: accounts_path
        end

        private

        def set_membership
          model =
            if params[:id].present?
              current_account.memberships.find(params[:id])
            else
              current_account.memberships.new(membership_params)
            end

          @membership = Storefront::MembershipViewModel.wrap(
            model,
            view_model_options.merge(account: current_account)
          )
        end

        def membership_params
          params.fetch(:membership, {}).permit(:role)
        end

        def find_or_create_user
          user = User.find_or_initialize_by(email: params[:email])
          return user if user.persisted?

          user.update(password: "#{SecureRandom.base58}B2b!")
          User::Signup.create(user: user)
          user
        end
      end
    end
  end
end
