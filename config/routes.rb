Rails.application.routes.draw do
  get 'bugs/add'
  get '/my-bugs' , to: 'bugs#index'
  get '/bugs/new' , to: 'bugs#goToProjectsIndex'
  get '/bugs/all-bugs' , to: 'bugs#goToProjectsIndex'
  get '/bugs/my-bugs' , to: 'bugs#goToProjectsIndex'
  get '/bugs/new-bugs' , to: 'bugs#goToProjectsIndex'
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
  get '/projects/:id/all-bugs', to: 'bugs#allBugs'
  get '/projects/:id/new-bugs', to: 'bugs#newBugs'
  get '/projects/:id/my-bugs', to: 'bugs#myBugs'

  post '/projects/:id/assign-bug', to: 'bugs#assignBug'
  post '/projects/:id/mark-bug', to: 'bugs#markBug'

  get '*all', to: 'error#notFound', constraints: lambda { |req|
    req.path.exclude? 'rails/active_storage'
  }

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  #get "*path", to: redirect('/error')
end
