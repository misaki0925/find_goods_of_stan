Rails.application.routes.draw do
  root 'articles#index'
  get 'articles/show'
  namespace :admin do
    get 'articles/index'
    get 'articles/edit'
    get 'articles/destroy'
    get 'articles/update'
  end
  
  get 'mistake_reports/new'
  get 'mistake_reports/create'
  namespace :admin do
    get 'mistake_reports/index'
    get 'mistake_reports/destroy'
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
