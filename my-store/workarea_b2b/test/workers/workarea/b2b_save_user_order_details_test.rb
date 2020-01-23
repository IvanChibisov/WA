require 'test_helper'

module Workarea
  class B2bSaveUserOrderDetailsTest < TestCase
    def test_save_payment_details
      account = create_account(require_account_payment: true)
      order = create_order(account_id: account.id)
      user = create_user

      assert_nil(SaveUserOrderDetails.new.save_payment_details(order, user))
    end

    def test_save_shipping_details
      account = create_account(require_account_address: true)
      order = create_order(account_id: account.id)
      user = create_user

      assert_nil(SaveUserOrderDetails.new.save_shipping_details(order, user))
    end
  end
end
