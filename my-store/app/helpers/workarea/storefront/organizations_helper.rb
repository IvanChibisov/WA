module Workarea
  module Storefront
    module OrganizationsHelper

      def membership_role_options
        Workarea.config.membership_roles.map do |role|
          [role.titleize, role]
        end
      end

      def payment_term_options
        Workarea.config.payment_terms.keys.unshift(['none', nil])
      end

      def organization_options
        result = []
        Workarea::Organization.all.each {|el| result.unshift(el.name)}
        result.unshift(['none', nil])
      end
    end
  end
end
