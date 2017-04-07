Rails.application.routes.draw do
  resources :categories
  devise_for :users
  resources :products
  root 'products#index'
  resource :cart, only: [:show] do
  	post "add",path: "add/:id", on: :member	
  	get :checkout
  end
  resources :orders, only: [:index,:create,:show,:update] do
  	member do 
  		get :new_payment
  		post :pay
  	end
  end

  end