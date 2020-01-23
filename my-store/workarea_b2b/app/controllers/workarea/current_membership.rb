module Workarea
  module CurrentMembership
    extend ActiveSupport::Concern

    included do
      before_action :set_membership_details, :validate_membership
      delegate :membership, :account, to: :'Workarea::Current', prefix: :current
      helper_method :current_membership, :current_account
    end

    def set_membership_details(user = current_user)
      return unless user.present?

      Current.membership =
        Organization::Membership.find_current(
          user.id,
          membership_id: session[:membership_id]
        )
    end

    def current_membership=(membership)
      Current.membership = membership
      session[:membership_id] = membership&.id
      session[:price_list_id] = Current.price_list_id
    end

    def login(user)
      super.tap do
        set_membership_details
        session[:price_list_id] = Current.price_list_id
      end
    end

    def logout
      super
      session.delete(:membership_id)
      session.delete(:price_list_id)
    end

    def impersonate_user(user)
      super.tap do
        session.delete(:membership_id)
        set_membership_details(user)
        session[:price_list_id] = Current.price_list_id
      end
    end

    def stop_impersonation
      super.tap do
        session.delete(:membership_id)
        session.delete(:price_list_id)
      end
    end

    def view_model_options
      super.merge(membership: current_membership)
    end

    private

    def validate_membership
      return unless Workarea.config.enforce_membership
      return unless logged_in?
      return unless Current.membership.nil?
      return if current_user.admin?

      logout
      flash[:error] = t('workarea.storefront.flash_messages.no_membership')
      redirect_to login_path
    end
  end
end
