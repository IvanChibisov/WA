module Workarea
  module Search
    class AdminAccounts
      include Query
      include AdminIndexSearch
      include AdminSorting
      include Pagination

      document Search::Admin

      def initialize(params = {})
        super(params.merge(type: 'organization_account'))
      end

      def facets
        super + [
          TermsFacet.new(self, 'organization'),
          TermsFacet.new(self, 'price_list')
        ]
      end
    end
  end
end
