module Workarea
  module Search
    class Admin
      class PricingPriceList < Search::Admin
        def type
          'price_list'
        end

        def search_text
          "price list #{model.id} - #{model.name}"
        end
      end
    end
  end
end
