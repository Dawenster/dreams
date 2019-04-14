Rails.application.routes.draw do
  resources :dreams, only: [:show] do
    collection do
      get :random
    end
  end
end
