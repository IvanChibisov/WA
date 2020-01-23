module Workarea
  class Order
    module Status
      class PendingReview
        include StatusCalculator::Status

        def in_status?
          model.account_id.present? && !model.reviewed?
        end
      end
    end
  end
end
