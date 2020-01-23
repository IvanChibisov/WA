module Workarea
  class Current < ActiveSupport::CurrentAttributes
    attribute :account, :membership, :price_list_id

    def membership=(membership)
      super.tap do
        self.account = membership&.account
        self.price_list_id = membership&.account&.price_list_id
      end
    end
  end
end
