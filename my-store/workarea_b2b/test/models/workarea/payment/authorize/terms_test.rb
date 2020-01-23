require 'test_helper'

module Workarea
  class Payment
    module Authorize
      class TermsTest < TestCase
        def test_complete!
          account = create_account(credit_limit: 6.to_m)
          Current.account = account

          payment = create_payment.tap { |p| p.build_terms }
          transaction = create_transaction(payment: payment, action: :authorize, amount: 5.to_m)

          Authorize::Terms.new(payment.terms, transaction).complete!
          assert(transaction.success?)
          assert_equal('purchase', transaction.action)
          assert_equal(5.to_m, account.reload.balance)

          payment = create_payment.tap { |p| p.build_terms }
          transaction = create_transaction(payment: payment, action: :authorize, amount: 5.to_m)
          Authorize::Terms.new(payment.terms, transaction).complete!

          refute(transaction.success?)
          assert_equal(5.to_m, account.reload.balance)
        end

        def test_cancel!
          account = create_account(balance: 20.to_m)
          Current.account = account

          payment = create_payment.tap { |p| p.build_terms }
          transaction = create_transaction(payment: payment, action: :authorize, amount: 5.to_m)

          Authorize::Terms.new(payment.terms, transaction).cancel!
          assert_equal(15.to_m, account.reload.balance)
        end
      end
    end
  end
end
