Rails.application.routes.draw do
  resources :bugs
  get '/users/password/new', to: 'error#notDeveloped'
  get 'projects/index'
  devise_for :users
  root 'home#index'
  resources :projects
  get '/users/', to: 'users#index'
  get '/projects/:id/manage-members', to: 'projects#manage'
  post '/projects/:id/add-members', to: 'projects#addUserToProject'
  get '/search-users/:name', to: 'users#search'
  get '/error', to: 'error#notFound'
  get '/not-developed', to: 'error#notDeveloped'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  get "*path", to: redirect('/error')
end
