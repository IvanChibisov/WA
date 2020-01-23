module Workarea
  class Organization
    include ApplicationDocument
    include Releasable

    field :name, type: String, localize: true
    has_many :accounts, class_name: 'Workarea::Organization::Account'

    def accounts_count
      accounts.count
    end
  end
end
