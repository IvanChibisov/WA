Workarea::Storefront::Engine.routes.draw do
  scope '(:locale)', constraints: Workarea::I18n.routes_constraint do
    resource :membership, only: :update

    resources :orders, only: [] do
      member { post :reorder }
    end

    post 'approve',  to: 'request#approve'
    post 'reject', to: 'request#reject'
    get 'edit_user_in_account', to: 'membership_account#edit'
    post 'update_user_in_account', to: 'membership_account#update'
    resource :accounts, only: [:show, :edit, :update] do
      get :transactions
      resources :addresses, controller: 'accounts/addresses'
      resources :credit_cards, controller: 'accounts/credit_cards'
      resources :memberships, controller: 'accounts/memberships'
      resources :orders, only: [:index, :show], controller: 'accounts/orders' do
        member { patch :review }
        collection { get :pending }
      end
    end

    resources :signups, only: [:edit, :update]
  end
end

Workarea::Admin::Engine.routes.draw do
  scope '(:locale)', constraints: Workarea::I18n.routes_constraint do
    resources :organizations
    resources :organization_accounts do
      member do
        get :addresses
        get :memberships
        get :credit
        put :reimburse
      end
    end
    resources :organization_memberships, only: [:create, :update, :destroy]

    resources :pricing_price_lists, except: [:edit, :update] do
      member do
        get :accounts
        get :pricing
      end
    end

    resources :users, only: [] do
      member { get :memberships }
    end
  end
end

if Workarea::Plugin.installed?('Workarea::Api::Admin')
  Workarea::Api::Admin::Engine.routes.draw do
    resources :organizations, except: [:new, :edit] do
      collection { patch 'bulk' }
    end

    resources :accounts, except: [:new, :edit] do
      collection { patch 'bulk' }
      resources :memberships, except: [:new, :edit]
    end

    resources :users, only: [] do
      resources :memberships, except: [:new, :edit]
    end

    resources :memberships, only: :show do
      collection { patch 'bulk' }
    end

    resources :price_lists, except: [:new, :edit] do
      collection { patch 'bulk' }
    end
  end
end
