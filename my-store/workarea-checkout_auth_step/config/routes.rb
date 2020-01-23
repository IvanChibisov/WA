Rails.application.routes.draw do
  Workarea::Storefront::Engine.routes.draw do
    scope '(:locale)', constraints: Workarea::I18n.routes_constraint do
      namespace :checkout do
          get   'authorization', to: 'authorization#authorization'
          patch 'authorization', to: 'authorization#update_authorization'
      end
    end
  end
end
