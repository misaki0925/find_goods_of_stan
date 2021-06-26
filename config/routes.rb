Rails.application.routes.draw do
  root 'articles#index'
  get 'articles/show'
  namespace :admin do
    resources :articles, only: %i[index edit destroy update]
  end

  resources :mistake_reports, only: %i[new create]
  namespace :admin do
    resources :mistake_reports, only: %i[index destroy]
  end
end
