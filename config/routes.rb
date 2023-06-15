Rails.application.routes.draw do
  devise_for :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  scope module: :store_front do
    resources :movies, only: [:index, :show] do
      resources :theatres, only: [:show] do
        resources :shows, only: [:show]
      end
    end
  end

  root 'store_front/movies#index'

  namespace :admin do
    resources :theatres
    resources :movies
    resources :shows
  end
end
