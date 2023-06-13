Rails.application.routes.draw do
  devise_for :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  namespace :store_front do
    resources :movies, only: [:index, :show]
  end
  root 'store_front/movies#index'

  namespace :admin do
    resources :theatres
    resources :movies
    resources :shows
  end
end
