Rails.application.routes.draw do
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  get 'home/index'
  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: 'home#index'

  resources :architects
  resources :homes
  get '/architect/:slug', to: redirect('/architects/%{slug}')
  resources :buildings
  get '/building/:slug', to: redirect('/buildings/%{slug}')
  resources :galleries
  get 'galleries/index'
  get 'galleries/show'
  resources :pages, path: '/about'
  resources :posts

  get '/postcards', action: :index, controller: 'postcards'
  get '/postcards/:subject', action: :subject, controller: 'postcards'
  get '/postcards/:subject/:id/', action: :show, controller: 'postcards', as: 'postcard_path'
end
