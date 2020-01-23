Rails.application.routes.draw do
  mount Workarea::Core::Engine => '/'
  mount Workarea::Admin::Engine => '/admin', as: 'admin'
  mount Workarea::Storefront::Engine => '/', as: 'storefront'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end

Workarea::Storefront::Engine.routes.draw do
  scope '(:locale)', constraints: Workarea::I18n.routes_constraint do
    resource :membership, only: :update

    resources :orders, only: [] do
      member { post :reorder }
    end

    resources :organization, only: :index
    resources :organization, only: :create

    post 'join_account', to: 'organization#join_account'
    get 'join_org', to: 'organization#join_org'
    post 'join', to: 'organization#join'
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
