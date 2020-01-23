module Workarea
  class Organization
    class CreditTransaction
      include ApplicationDocument

      field :amount, type: Money, default: 0.to_m
      field :action, type: String

      belongs_to :account,
        class_name: 'Workarea::Organization::Account',
        index: true

      validates :amount, presence: true
      validates :account, presence: true

      scope :for_account, ->(id) { where(account_id: id) }
    end
  end
end
