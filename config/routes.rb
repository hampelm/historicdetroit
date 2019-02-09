Rails.application.routes.draw do
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  get 'home/index'
  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: 'home#index'

  resources :architects
  get '/architect/:slug', to: redirect('/architects/%{slug}')
  resources :buildings
  get '/building/:slug', to: redirect('/buildings/%{slug}')
  resources :galleries
  get 'galleries/index'
  get 'galleries/show'
  resources :pages, path: '/about'
  resources :posts

  # Postcards are nested by subject
  get '/postcards', action: :index, controller: 'postcards'
  get '/postcards/:subject', action: :subject, controller: 'postcards'
  get '/postcards/:subject/:id/', action: :show, controller: 'postcards', as: 'postcard_path'

  # We have some legacy paths for homes
  get '/homes', action: :index, controller: 'homes'
  get '/homes/:subject', action: :subject, controller: 'homes'
  get '/home/:id', to: redirect('/buildings/%{id}', status: 302)
  get '/houses', to: redirect('/homes', status: 302)
  get '/houses/:subject', to: redirect('/homes/%{subject}', status: 302)
  get '/houses/:id', to: redirect('/buildings/%{id}', status: 302)
end
