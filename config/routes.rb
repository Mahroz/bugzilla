Rails.application.routes.draw do
  get 'bugs/add'
  get '/bugs/new' , to: 'projects#index'
  resources :bugs
  get '/users/password/new', to: 'error#notDeveloped'
  get 'projects/index'
  devise_for :users
  root 'home#index'
  resources :projects
  get '/users/', to: 'users#index'
  get '/projects/:id/manage-members', to: 'projects#manage'
  post '/projects/:id/add-members', to: 'projects#addUserToProject'
  post '/projects/:id/remove-members', to: 'projects#removeUserFromProject'
  get '/search-users/:name', to: 'users#search'
  get '/error', to: 'error#notFound'
  get '/not-developed', to: 'error#notDeveloped'


  get '/projects/:id/report-bugs', to: 'bugs#new'
  post '/projects/:id/create-bug', to: 'bugs#create'

  get '*all', to: 'error#notFound', constraints: lambda { |req|
    req.path.exclude? 'rails/active_storage'
  }

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  #get "*path", to: redirect('/error')
end
