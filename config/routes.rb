Rails.application.routes.draw do
  devise_for :users

  root to: 'questions#index'

  concern :ratingable do
    member do
      post :like
      post :dislike
      post :cancel
    end
  end

  resources :questions, except: :edit, concerns: :ratingable do
    resources :answers, only: [:create, :update, :destroy], concerns: :ratingable, shallow: true do
      member do
        put :set_best
      end
    end
  end

  resources :attachments, only: :destroy
end
