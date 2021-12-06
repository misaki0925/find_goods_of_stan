Rails.application.routes.draw do
  root to: 'articles#home'
  
  resources :articles, only: %i[show index]
  get '/line_page', to: 'articles#line'

  resource :reports, only: %i[new create]

  namespace :admins do
    get '/login', to: 'sessions#new', as: :login
    post '/login', to: 'sessions#create'
    delete '/logout', to: 'sessions#destroy', as: :logout
    resources :articles, only: %i[update destroy edit index]
    resources :reports, only: %i[destroy index]
  end


end
