module Workarea
  class Payment
    class Refund
      class Terms
        include OperationImplementation

        def complete!
          account&.refund!(transaction.amount)

          transaction.response = ActiveMerchant::Billing::Response.new(
            account.present?,
            I18n.t(
              'workarea.payment.terms_refund',
              amount: transaction.amount,
              account: account&.name
            )
          )
        end

        def cancel!
          account&.purchase!(transaction.amount)

          transaction.response = ActiveMerchant::Billing::Response.new(
            account.present?,
            I18n.t(
              'workarea.payment.terms_authorization',
              amount: transaction.amount,
              account: account&.name
            )
          )
        end

        private

        def account
          return unless transaction.payment.account_profile.present?
          @account ||= Organization::Account.find(
            transaction.payment.account_profile.reference
          )
        end
      end
    end
  end
end
