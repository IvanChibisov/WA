module Workarea
  module Storefront
    module MembershipsHelper
      def available_memberships
        return [] unless logged_in?
        @available_memberships ||=
          current_user.memberships.includes(account: :organization).select(&:active?)
      end

      def membership_options
        available_memberships.map do |membership|
          [membership.account_name, membership.id]
        end
      end

      def membership_role_options
        Workarea.config.membership_roles.map do |role|
          [role.titleize, role]
        end
      end
    end
  end
end
