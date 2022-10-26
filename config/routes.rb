Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  # resources only: %i[index new]

  root to: 'welcome#index'
  get '/register', to: 'welcome#register'
  get '/login', to: 'users#login_form'
  post '/login', to: 'users#login_user'
  get '/logout', to: 'users#logout'

  get '/discover', to: 'users#discover'
  get '/dashboard', to: 'users#dashboard' # maybe we use show pages as dashboards
  get '/movies', to: 'users#movies'
  get '/movies/:movie_id', to: 'movies#show'
  get '/movies/:movie_id/viewing_party/new', to: 'viewing_parties#new'
  post '/movies/:movie_id/viewing_party/create', to: 'viewing_parties#create'

  resources :users, only: %i[create]
end
