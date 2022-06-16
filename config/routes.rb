Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"

  root "tweets#index"

  get "/welcome", to: "tweets#index"
  get "/about", to: "welcome#about"

  resources :users do
    resources :follows, only: %i[new create destroy]
    member do
      get :following, :followers
    end
  end
  resources :tweets do
    resources :likes, only: %i[index new create destroy]
  end

  namespace :api do 
    resources :users, only: %i[index show create update destroy] do
      resources :follows, only: %i[create destroy]
      member do
        get :following, :followers
      end
    end
    
    resources :tweets, only: %i[index show create update destroy] do 
      resources :likes, only: %i[index create destroy]
    end
  end
end
