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

post '/setting_request', to: 'line_users#setting_request'
post '/submit_setting', to: 'line_users#submit_setting'
post '/set_member', to: 'line_users#set_member'
post '/off_member', to: 'line_users#off_member'
post '/all_member_setting', to: 'line_users#all_member_setting'

post '/callback', to: 'line_users#callback'



end
