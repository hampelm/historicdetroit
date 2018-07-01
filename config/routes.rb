Rails.application.routes.draw do
  get 'galleries/index'
  get 'galleries/show'
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  get 'home/index'
  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: "home#index"

  resources :architects
  get '/architect/:slug', to: redirect('/architects/%{slug}')
  resources :buildings
  get '/building/:slug', to: redirect('/buildings/%{slug}')
  resources :galleries
  resources :pages, path: '/about'
  resources :posts
end
