require 'test_helper'

module Workarea
  class Payment
    class Refund
      class TermsTest < TestCase
        def test_complete!
          account = create_account(balance: 20.to_m)
          profile = Payment::Profile.lookup(PaymentReference.new(account))

          payment = create_payment(account_profile: profile).tap { |p| p.build_terms }
          transaction = create_transaction(payment: payment, action: :refund, amount: 5.to_m)

          Refund::Terms.new(payment.terms, transaction).complete!
          assert(transaction.success?)
          assert_equal(15.to_m, account.reload.balance)

          payment = create_payment.tap { |p| p.build_terms }
          transaction = create_transaction(payment: payment, action: :refund, amount: 5.to_m)

          Refund::Terms.new(payment.terms, transaction).complete!
          refute(transaction.success?)
          assert_equal(15.to_m, account.reload.balance)
        end

        def test_cancel!
          account = create_account(balance: 20.to_m)
          profile = Payment::Profile.lookup(PaymentReference.new(account))

          payment = create_payment(account_profile: profile).tap { |p| p.build_terms }
          transaction = create_transaction(payment: payment, action: :refund, amount: 5.to_m)

          Refund::Terms.new(payment.terms, transaction).cancel!
          assert_equal(25.to_m, account.reload.balance)

          payment = create_payment.tap { |p| p.build_terms }
          transaction = create_transaction(payment: payment, action: :refund, amount: 5.to_m)

          Refund::Terms.new(payment.terms, transaction).cancel!
          refute(transaction.success?)
          assert_equal(25.to_m, account.reload.balance)
        end
      end
    end
  end
end
