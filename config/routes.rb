Rails.application.routes.draw do
  devise_for :users
  get '/legal', to: 'pages#legal', as: 'legal'
  root to: 'pages#home'
  resources :events
end
