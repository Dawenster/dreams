Rails.application.routes.draw do
  resources :dreams do
    collection do
      get :random
    end
  end
end
