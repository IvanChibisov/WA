require 'test_helper'

module Workarea
  module Storefront
    module Accounts
      class CreditCardsIntegrationTest < Workarea::IntegrationTest
        setup :set_membership

        def set_membership
          @user = create_user(email: 'bcrouse@workarea.com', password: 'W3bl1nc!')
          @account = create_account
          @membership = create_membership(user: @user, account: @account, role: 'administrator')

          set_current_user(@user)
        end

        def test_create
          post storefront.accounts_credit_cards_path,
               params: {
                 credit_card: {
                   number: '1',
                   first_name: 'Ben',
                   last_name: 'Crouse',
                   month: '1',
                   year: (Time.current.year + 1).to_s,
                   cvv: '999'
                 }
               }

          assert_redirected_to(storefront.accounts_path)

          payment_profile = Payment::Profile.lookup(PaymentReference.new(@account))

          credit_card = payment_profile.credit_cards.first
          assert_equal('Ben', credit_card.first_name)
          assert_equal('Crouse', credit_card.last_name)
          assert_equal(1, credit_card.month)
          assert_equal(Time.current.year + 1, credit_card.year)
          assert(credit_card.token.present?)
        end

        def test_update
          profile = Payment::Profile.lookup(PaymentReference.new(@account))
          credit_card = create_saved_credit_card(profile: profile)

          patch storefront.accounts_credit_card_path(credit_card),
                params: {
                  credit_card: {
                    month: '2',
                    year: '2020',
                    cvv: '999'
                  }
                }

          credit_card.reload
          assert_equal(2, credit_card.month)
          assert_equal(2020, credit_card.year)
        end

        def test_destroy
          profile = Payment::Profile.lookup(PaymentReference.new(@account))
          credit_card = create_saved_credit_card(profile: profile)

          delete storefront.accounts_credit_card_path(credit_card)
          payment_profile = Payment::Profile.lookup(PaymentReference.new(@account))
          assert(payment_profile.credit_cards.empty?)
        end


        def test_requires_administator
          @membership.update(role: 'approver')

          post storefront.accounts_credit_cards_path,
               params: {
                 credit_card: {
                   number: '1',
                   first_name: 'Ben',
                   last_name: 'Crouse',
                   month: '1',
                   year: (Time.current.year + 1).to_s,
                   cvv: '999'
                 }
               }

          assert_redirected_to(storefront.accounts_path)
          assert(flash[:info].present?)
          profile = Payment::Profile.lookup(PaymentReference.new(@account))
          assert(profile.credit_cards.empty?)
        end
      end
    end
  end
end
