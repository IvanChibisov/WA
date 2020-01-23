module Workarea
  class Organization
    class Membership
      include ApplicationDocument

      field :role, type: String, default: Workarea.config.membership_roles.first
      field :default, type: Boolean, default: false

      belongs_to :user,
        class_name: 'Workarea::User',
        index: true,
        optional: false
      belongs_to :account,
        class_name: 'Workarea::Organization::Account',
        index: true,
        optional: false

      validates :account, presence: true
      validates :user, presence: true,  uniqueness: { scope: :account }
      validates :role, presence: true,
                       inclusion: { in: Workarea.config.membership_roles }

      after_save :update_default

      index(role: 1)

      scope :administrators, -> { where(role: 'administrator') }
      scope :approvers, -> { where(:role.in => %w(administrator approver)) }

      delegate :name, to: :account, prefix: true
      delegate :price_list_id, :credit_limit, :require_account_address,
               :require_account_payment, :require_order_approval,
               :payment_terms, :tax_code, :organization,
               to: :account
      delegate :name, to: :organization, prefix: true
      delegate :name, to: :user, prefix: true

      def administrator?
        role == 'administrator'
      end

      def approver?
        administrator? || role == 'approver'
      end

      def shopper?
        approver? || role == 'shopper'
      end

      def self.find_current(user_id, membership_id: nil)
        memberships =
          where(user_id: user_id)
            .order(created_at: :asc)
            .includes(account: :organization)
            .select(&:active?)

        membership =
          if membership_id.present?
            memberships.detect { |m| m.id.to_s == membership_id.to_s }
          end

        membership || memberships.detect(&:default?) || memberships.first
      end

      def active?
        account.active? && organization.active?
      end

      private

      def update_default
        return unless default?

        user.memberships
            .where(default: true)
            .excludes(id: id)
            .update_all(default: false)
      end
    end
  end
end
