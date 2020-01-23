module Workarea
  module Storefront
    module Accounts
      module RolePermission
        def require_administrator
          return if current_membership.administrator?

          flash[:info] = t('workarea.storefront.flash_messages.requires_administrator')
          redirect_to accounts_path
          false
        end

        def require_approver
          return if current_membership.approver?

          flash[:info] = t('workarea.storefront.flash_messages.requires_approver')
          redirect_to accounts_path
          false
        end
      end
    end
  end
end
