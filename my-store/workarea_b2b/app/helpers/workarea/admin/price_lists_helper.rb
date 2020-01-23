module Workarea
  module Admin
    module PriceListsHelper
      def price_list_options
        @price_list_options ||=
          Pricing::PriceList.all
                            .map { |list| [list.name, list.id] }
                            .unshift(['none', nil])
      end
    end
  end
end
