Rails.application.routes.draw do
  Workarea::Admin::Engine.routes.draw do
    scope '(:locale)', constraints: Workarea::I18n.routes_constraint do
      post 'add_repeat_block', to: 'repeat_block#add_repeat_block'
      post 'delete_repeat_block', to: 'repeat_block#delete_repeat_block'
    end
  end
end
