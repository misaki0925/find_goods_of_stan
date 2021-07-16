Rails.application.routes.draw do
  root to: 'articles#index'
  
  resources :articles, only: [:show, :index] do
    collection do
      get 'search', to: 'articles#search'
    end
  end
  namespace :admins do
    resources :articles, only: [:update, :destroy, :edit, :index] do
      collection do
        get 'search', to: 'admins/articles#search'
      end
    end
  end
  resources :reports, only: [:new, :create]
  namespace :admins do
  resources :reports, only: [:destroy, :index]
  end

end
