module Workarea
  class Payment
    module Authorize
      class Terms
        include OperationImplementation

        def complete!
          if Current.account.present? && Current.account.available_credit >= transaction.amount
            Current.account&.purchase!(transaction.amount)

            transaction.action = 'purchase'
            transaction.response = ActiveMerchant::Billing::Response.new(
              true,
              I18n.t(
                'workarea.payment.terms_authorization',
                amount: transaction.amount,
                account: Current.account&.name
              )
            )
          else
            transaction.response = ActiveMerchant::Billing::Response.new(
              false,
              I18n.t(
                'workarea.payment.terms_insufficient_credit',
                account: Current.account&.name
              )
            )
          end
        end

        def cancel!
          Current.account&.refund!(transaction.amount)

          transaction.response = ActiveMerchant::Billing::Response.new(
            true,
            I18n.t(
              'workarea.payment.terms_cancellation',
              amount: transaction.amount,
              account: Current.account&.name
            )
          )
        end
      end
    end
  end
end
