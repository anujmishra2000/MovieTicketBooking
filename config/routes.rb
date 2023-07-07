Rails.application.routes.draw do
  devise_for :users

  scope module: :store_front do
    resources :movies, only: [:index, :show] do
      resources :theatres, only: [:show] do
        resources :shows, only: [:show]
      end
    end
  end

  resources :user_reactions do
    member do
      post :up_vote
      post :down_vote
    end
  end

  root 'store_front/movies#index'

  namespace :admin do
    resources :theatres
    resources :movies
    resources :shows do
      member do
        patch :cancel
        patch :activate
      end
    end
    resources :orders do
      post :refund, on: :member
    end
    resources :reports, only: :index do
      collection do
        get :users_spendings
        get :theatres_revenue
      end
    end
  end

  resources :orders do
    member do
      get :cart
      post :refund
    end
  end

  resources :line_items, only: :destroy

  post 'checkout/:number', to: 'payments#create', as: 'checkout'
  resources :payments do
    member do
      get :success
      get :cancel
    end
  end

  get 'my-profile', to: 'users#show'

  namespace :api do
    resources :movies, only: :index
    resources :orders, only: :index
  end
end
