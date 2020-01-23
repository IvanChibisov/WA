module Workarea
  module Factories
    module B2b
      Factories.add(self)

      def create_organization(overrides = {})
        attributes = { name: 'Test Organization' }.merge(overrides)
        Organization.create!(attributes)
      end

      def create_account(overrides = {})
        attributes = {
          organization: create_organization,
          name: 'Test Account'
        }.merge(overrides)

        Organization::Account.create!(attributes)
      end

      def create_membership(overrides = {})
        attributes = {
          account: create_account,
          user: create_user,
          role: Workarea.config.membership_roles.first
        }.merge(overrides)

        Organization::Membership.create!(attributes)
      end

      def create_price_list(overrides = {})
        attributes = { name: 'Test Price List' }.merge(overrides)
        Workarea::Pricing::PriceList.create!(attributes)
      end
    end
  end
end
