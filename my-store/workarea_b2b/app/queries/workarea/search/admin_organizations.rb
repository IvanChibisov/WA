module Workarea
  module Search
    class AdminOrganizations
      include Query
      include AdminIndexSearch
      include AdminSorting
      include Pagination

      document Search::Admin

      def initialize(params = {})
        super(params.merge(type: 'organization'))
      end
    end
  end
end
