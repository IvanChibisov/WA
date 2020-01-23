module Workarea
  class Organization
    class Account
      include ApplicationDocument
      include Mongoid::Document::Taggable
      include Commentable
      include User::Addresses
      include Releasable

      field :name, type: String, localize: true
      field :price_list_id, type: String
      field :payment_terms, type: String
      field :tax_code, type: String
      field :credit_limit, type: Money
      field :balance, type: Money, default: 0.to_m
      field :require_account_address, type: Boolean, default: false
      field :require_account_payment, type: Boolean, default: false
      field :require_order_approval, type: Boolean, default: false

      has_many :memberships, class_name: 'Workarea::Organization::Membership'
      has_many :credit_transactions, class_name: 'Workarea::Organization::CreditTransaction'
      belongs_to :organization,
        class_name: 'Workarea::Organization',
        index: true,
        optional: true

      validates :name, presence: true
      validates :organization, presence: true

      def memberships_count
        memberships.count
      end

      # For internal system use only. Used to tie an account to a payment
      # profile. Please don't use it anywhere else.
      def email
        "#{id}@internal"
      end

      def available_credit
        return 0.to_m unless credit_limit.present?
        credit_limit - balance
      end

      def payment_tenders
        Workarea.config.payment_terms[payment_terms] || []
      end

      def allows_terms?
        payment_tenders.include?(:terms) && credit_limit > 0
      end

      def purchase!(amount)
        inc('balance.cents' => amount.cents)
        credit_transactions.create!(
          amount: amount * -1,
          action: I18n.t('workarea.organization_credit_transaction.purchase')
        )
      end

      def refund!(amount)
        inc('balance.cents' => -1 * amount.cents)
        credit_transactions.create!(
          amount: amount,
          action: I18n.t('workarea.organization_credit_transaction.refund')
        )
      end

      def reimburse!(amount)
        inc('balance.cents' => -1 * amount.cents)
        credit_transactions.create!(
          amount: amount,
          action: I18n.t('workarea.organization_credit_transaction.reimbursement')
        )
      end
    end
  end
end
