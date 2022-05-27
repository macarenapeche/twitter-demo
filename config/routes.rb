Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"

  root "tweets#index"

  get "/welcome", to: "tweets#index"
  get "/about", to: "welcome#about"

  resources :users do
    resources :follows
  end
  resources :tweets do
    resources :likes
  end
  
end
