module Workarea
  module Admin
    class OrganizationViewModel < ApplicationViewModel
      def accounts
        @accounts ||= Admin::AccountViewModel.wrap(
          model.accounts,
          options
        )
      end
    end
  end
end
