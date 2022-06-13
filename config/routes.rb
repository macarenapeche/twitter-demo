Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"

  root "tweets#index"

  get "/welcome", to: "tweets#index"
  get "/about", to: "welcome#about"

  resources :users do
    resources :follows, only: [:index, :show, :new, :create, :destroy]
  end
  resources :tweets do
    resources :likes, only: [:index, :show, :new, :create, :destroy]
  end
  
end
