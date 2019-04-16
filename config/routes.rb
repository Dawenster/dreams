Rails.application.routes.draw do
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'

  resources :dreams, only: [:show, :create] do
    collection do
      get :random
    end
  end

  resources :elements, only: [:index]
end
