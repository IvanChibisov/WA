module Workarea
  class Payment
    class Capture
      class Terms
        include OperationImplementation

        def complete!
          # noop, authorization does capture
          transaction.response = ActiveMerchant::Billing::Response.new(
            true,
            I18n.t('workarea.payment.terms_capture')
          )
        end

        def cancel!
          # noop, nothing to cancel
          transaction.response = ActiveMerchant::Billing::Response.new(
            true,
            I18n.t('workarea.payment.terms_capture')
          )
        end
      end
    end
  end
end
