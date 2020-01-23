module Workarea
  class Payment
    class Tender
      class Terms < Tender

        field :purchase_order_number, type: String

        def slug
          :terms
        end
      end
    end
  end
end
