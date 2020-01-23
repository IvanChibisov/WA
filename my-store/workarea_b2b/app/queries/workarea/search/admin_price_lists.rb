module Workarea
  module Search
    class AdminPriceLists
      include Query
      include AdminIndexSearch
      include AdminSorting
      include Pagination

      document Search::Admin

      def initialize(params = {})
        super(params.merge(type: 'price_list'))
      end
    end
  end
end
