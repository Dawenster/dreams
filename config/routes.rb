Rails.application.routes.draw do
  resources :dreams, only: [:show, :create] do
    collection do
      get :random
    end
  end

  resources :elements, only: [:index]
end
