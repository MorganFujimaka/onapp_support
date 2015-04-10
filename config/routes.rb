Rails.application.routes.draw do
  devise_for :users
  
  root 'tickets#index'

  resources :tickets, except: :destroy do
    member do
      patch :change_status
      patch :change_assignee
    end
    resources :replies, only: [:create]
  end

  get 'search', to: 'search#search'
end
