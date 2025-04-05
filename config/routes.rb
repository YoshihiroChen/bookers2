Rails.application.routes.draw do

  root to: 'home#top'
  get 'home/about', to: 'home#about'


  devise_for :users

  resources :users, only: [:index, :show, :edit, :update]

  resources :books

  resources :books do
    resource :favorite, only: [:create, :destroy]
    resources :book_comments, only: [:create, :destroy]
  end
end