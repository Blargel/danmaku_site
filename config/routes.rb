BulletForge::Application.routes.draw do

  resources :users, :path => 'u' do
    resources :comments, :only => [:index, :create, :destroy]
    resources :projects, :path => 'p' do
      resources :versions, :path => 'v' do
        resources :comments, :only => [:index, :create, :destroy]
        resource :archive, :only => [:show]
        resources :votes
      end
    end
  end

  get '/u/:id/delete' => 'users#delete', :as => :user_delete

  resource :user_session
  resource :sitemap, :only => [:show]

  get '/login' => 'user_sessions#new', :as => :login
  get '/logout' => 'user_sessions#destroy', :as => :logout

  post '/upload/archive' => 'archives#create', :as => :upload_archive
  post '/upload/image' => 'images#create', :as => :upload_image

  get '/search' => 'search#search', :as => :search

  root :to => 'home#show'
  match '/:controller(/:action(/:id))'
end
