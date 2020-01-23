require 'workarea/b2b'

module Workarea
  module B2b
    class Engine < ::Rails::Engine
      include Workarea::Plugin
      isolate_namespace Workarea::B2b

      config.to_prepare do
        Admin::ApplicationController.helper(Admin::AccountsHelper)
        Admin::ApplicationController.helper(Admin::PriceListsHelper)
        Admin::ApplicationController.include(CurrentMembership)

        Storefront::ApplicationController.include(CurrentMembership)
        Storefront::ApplicationController.helper(Storefront::MembershipsHelper)
      end
    end
  end
end
