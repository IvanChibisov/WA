module Workarea
  module Admin
    module AccountsHelper
      def organization_options
        @organization_options ||= Organization.all.map do |organization|
          [organization.name, organization.id]
        end
      end

      def account_options
        @account_options ||=
          Organization::Account.all.includes(:organization).map do |account|
            ["#{account.organization.name} / #{account.name}", account.id]
          end
      end

      def membership_role_options
        Workarea.config.membership_roles.map do |role|
          [role.titleize, role]
        end
      end

      def payment_term_options
        Workarea.config.payment_terms.keys.unshift(['none', nil])
      end
    end
  end
end
