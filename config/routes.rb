Rails.application.routes.draw do
  scope "(:locale)", locale: /en|vi/ do
    root "static_pages#home"
    get "/help", to: "static_pages#help"
    get "/signup", to: "users#new"
    get "/login", to: "sessions#new"
    post "/login", to: "sessions#create"
    delete "/logout", to: "sessions#destroy"
    resources :users, except: :new
    resources :account_activations, only: :edit
    resources :password_resets, except: [:index, :show, :destroy]
    resources :microposts, only: [:create, :destroy]
  end
end
