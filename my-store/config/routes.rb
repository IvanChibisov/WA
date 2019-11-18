Rails.application.routes.draw do
  mount Workarea::Core::Engine => '/'
  mount Workarea::Admin::Engine => '/admin', as: 'admin'
  mount Workarea::Storefront::Engine => '/', as: 'storefront'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
