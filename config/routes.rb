Rails.application.routes.draw do
  resources :book_histories
  get 'homes/new'
  get 'homes/show' => 'homes#show', as: :home 
  get 'sessions/signup' => 'sessions#signup', as: :signup
  post 'sessions/new_user' => 'sessions#new_user'
  root 'sessions#new'
  get 'login' => 'sessions#new', as: :loginpage
  post 'login' => 'sessions#create'
  delete 'logout' => 'sessions#destroy'

  get 'books/:id/borrow' => 'books#borrow', :as => :borrow_book
  get 'book_histories/:data/index' => 'book_histories#index', :as =>:check_user_history
  get 'books/:id/request' => 'books#request_book', :as => :request_book
  get 'books/:id/return' => 'books#return', :as => :return_book
  get 'books/:id/cancel_request' => 'books#cancel_request', :as => :cancel_request_book

  resources :searches
  resources :books 
  resources :users 

  match ':controller(/:action(/:id))', :via => :get
end
