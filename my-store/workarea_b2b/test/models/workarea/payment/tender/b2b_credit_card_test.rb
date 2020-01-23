require 'test_helper'

module Workarea
  class Payment
    class Tender
      class B2bCreditCardTest < TestCase
        def test_saved_card
          user_profile = Payment::Profile.lookup(PaymentReference.new(create_user))
          account_profile = Payment::Profile.lookup(PaymentReference.new(create_account))
          payment = create_payment(profile: user_profile, account_profile: account_profile)

          user_card = create_saved_credit_card(profile: user_profile)
          account_card = create_saved_credit_card(profile: account_profile)

          tender = Payment::Tender::CreditCard.new(payment: payment)
          assert_nil(tender.saved_card)

          tender = Payment::Tender::CreditCard.new(payment: payment)
          tender.saved_card_id = '1234'
          assert_nil(tender.saved_card)

          tender = Payment::Tender::CreditCard.new(payment: payment)
          tender.saved_card_id = user_card.id
          assert_equal(user_card, tender.saved_card)

          tender = Payment::Tender::CreditCard.new(payment: payment)
          tender.saved_card_id = account_card.id
          assert_equal(account_card, tender.saved_card)
        end
      end
    end
  end
end
