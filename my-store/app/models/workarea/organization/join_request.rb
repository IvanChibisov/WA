module Workarea
  class Organization
    class JoinRequest
      include ApplicationDocument

      field :email, type: String, default: "sample@gmail.com"
      belongs_to :user,
        class_name: 'Workarea::User',
        index: true,
        optional: false
      belongs_to :account,
        class_name: 'Workarea::Organization::Account',
        index: true,
        optional: false

      validates :user, presence: true
      validates :email, presence: true
      validates :account, presence: true
    end
  end
end
