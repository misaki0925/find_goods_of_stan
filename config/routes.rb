Rails.application.routes.draw do
  # if Rails.env.development?
  #   get '/login_as/:user_id', to: 'development/sessions#login_as'
  # end

  root to: 'articles#home'
  
  resources :articles, only: %i[show index]
  get '/line_page', to: 'articles#line'

  resources :reports, only: %i[new create]

  namespace :admins do
    get '/login', to: 'sessions#new', as: :login
    post '/login', to: 'sessions#create'
    delete '/logout', to: 'sessions#destroy', as: :logout
    resources :articles, only: %i[update destroy edit index] do
      collection do
        get 'search', to: 'articles#search'
      end
    end
    resources :reports, only: %i[destroy index]
  end


end
