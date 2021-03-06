Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  namespace :api, { format: 'json' } do
    namespace :v1 do
      resources :comments, only: [:index, :create, :update, :destroy]
    end
  end
end
