Rails.application.routes.draw do
  use_doorkeeper
  devise_for :users, controllers: { omniauth_callbacks: 'omniauth_callbacks' }

  resources :users, only: [] do
    member do
      get :setup_email
      patch :confirm_email
    end
  end

  root to: 'questions#index'

  concern :ratingable do
    member do
      post :like
      post :dislike
      post :cancel
    end
  end
  
  concern :commentable do
    resources :comments, only: :create, shallow: true
  end

  resources :questions, except: :edit, concerns: [:ratingable, :commentable] do
    resources :answers,
              only: [:create, :update, :destroy],
              concerns: [:ratingable, :commentable],
              shallow: true do
      member do
        put :set_best
      end
    end
  end

  resources :attachments, only: :destroy

  namespace :api do
    namespace :v1 do
      resources :profiles, only: :index do
        get :me, on: :collection
      end

      resources :questions, only: [:index, :show, :create] do
        resources :answers, only: [:index, :show, :create], shallow: true
      end
    end
  end
end
