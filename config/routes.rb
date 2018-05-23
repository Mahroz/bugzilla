Rails.application.routes.draw do
  get 'projects/index'
  devise_for :users
  get 'users/new'
  root 'home#index'
  resources :projects
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
