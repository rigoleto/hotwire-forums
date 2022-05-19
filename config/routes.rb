Rails.application.routes.draw do
  resources :categories
  devise_for :users
  resources :discussions do
    resources :posts, module: :discussions
    collection do
      get "category/:id", to: "categories/discussions#index", as: :category
    end
    resources :notifications, module: :discussions
  end
  root to: "main#index"
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
