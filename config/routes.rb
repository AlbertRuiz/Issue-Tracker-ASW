Rails.application.routes.draw do
  
  get 'sessions/new'

 # get  '/signup', to: 'users#new'
  #post '/signup', to: 'users#create'
#  get '/issues', to: 'issues#index'
#  post '/comments', to: 'comments#create'
#  delete '/comments', to: 'comments#destroy'
#  patch '/comments', to: 'comments#update'
  get    '/login',   to: 'sessions#new'
  post   '/login',   to: 'sessions#create'
#  delete '/logout',  to: 'sessions#destroy'
#  post '/votes',  to: 'votes#create'
#  delete '/votes',  to: 'votes#destroy'
#  post '/watches',  to: 'watches#create'
#  delete '/watches',  to: 'watches#destroy'
#  patch '/issues', to: 'issues#status_edit'
#  put '/issues', to: 'issues#spam'
#  put '/comments', to: 'comments#spam'
#  post '/issues/:id', to: 'issues#delete_attachment'
  get 'auth/:provider/callback', to: 'sessions#google_create'
  get 'auth/failure', to: redirect('/')

  root 'sessions#new'
  
  resources :issues
  resources :users
  resources :comments

  post '/issues/:id/comments', to: 'issues#comment_issue'


end