require 'test_helper'

module Workarea
  class Organization
    class AccountTest < TestCase
      def test_purchase!
        account = create_account(credit_limit: 100.to_m)

        assert(account.purchase!(10.to_m))
        account.reload

        assert_equal(10.to_m, account.balance)
        assert_equal(1, account.credit_transactions.count)

        transaction = account.credit_transactions.first
        assert_equal(t('workarea.organization_credit_transaction.purchase'), transaction.action)
        assert_equal(-10.to_m, transaction.amount)
      end

      def test_refund!
        account = create_account(credit_limit: 100.to_m, balance: 50.to_m)

        assert(account.refund!(10.to_m))
        account.reload

        assert_equal(40.to_m, account.balance)
        assert_equal(1, account.credit_transactions.count)

        transaction = account.credit_transactions.first
        assert_equal(t('workarea.organization_credit_transaction.refund'), transaction.action)
        assert_equal(10.to_m, transaction.amount)
      end

      def test_reimburse!
        account = create_account(credit_limit: 100.to_m, balance: 50.to_m)

        assert(account.reimburse!(10.to_m))
        account.reload

        assert_equal(40.to_m, account.balance)
        assert_equal(1, account.credit_transactions.count)

        transaction = account.credit_transactions.first
        assert_equal(t('workarea.organization_credit_transaction.reimbursement'), transaction.action)
        assert_equal(10.to_m, transaction.amount)
      end
    end
  end
end
