module Workarea
  module Admin
    class PriceListViewModel < ApplicationViewModel
      include CommentableViewModel

      def skus
        @skus ||= SearchViewModel.wrap(
          Search::AdminPricingSkus.new(price_lists: model.id)
        )
      end

      def accounts
        @accounts ||= SearchViewModel.wrap(
          Search::AdminAccounts.new(price_list: model.id)
        )
      end

      def timeline
        @timeline ||= TimelineViewModel.new(model)
      end
    end
  end
end
