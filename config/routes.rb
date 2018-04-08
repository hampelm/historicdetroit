Rails.application.routes.draw do
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  get 'home/index'
  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: "home#index"

  resources :architects
  get '/architect/:slug', to: redirect('/architects/%{slug}')
  resources :buildings
  get '/building/:slug', to: redirect('/buildings/%{slug}')
  resources :photos
  resources :posts
end
