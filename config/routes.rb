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
  get '/map', action: :map, controller: 'buildings'

  resources :galleries
  get 'galleries/index'
  get 'galleries/show'

  # We have some special pages
  resources :pages, path: '/about'
  get '/shop', to: redirect('/about/shop', status: 302)

  resources :posts
  
  # RSS Feed
  get '/feed', to: 'feed#index', defaults: { format: 'rss' }
  
  resources :search
  resources :streets

  # Postcards
  get '/postcards', action: :index, controller: 'postcards'
  get '/buildings/:slug/postcards', action: :building, controller: 'postcards'
  get '/postcards/:subject', action: :subject, controller: 'postcards'
  get '/postcards/:slug/:id/', action: :show, controller: 'postcards', as: 'postcard_path'

  # We have some legacy paths for homes
  get '/homes', action: :index, controller: 'homes'
  get '/homes/:subject', action: :subject, controller: 'homes'
  get '/home/:id', to: redirect('/buildings/%{id}', status: 302)
  get '/houses', to: redirect('/homes', status: 302)
  get '/houses/:subject', to: redirect('/homes/%{subject}', status: 302)
  get '/houses/:id', to: redirect('/buildings/%{id}', status: 302)
end
