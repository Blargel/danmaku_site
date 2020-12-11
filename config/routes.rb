BulletForge::Application.routes.draw do
  resources :users, :path => 'u' do
    resources :projects, :path => 'p' do
      resource :archive, :only => [:show, :destroy]
      get '/v(/:id(/archive))' => 'versions#redirect' # legacy routing
    end
  end

  get '/u/:id/delete' => 'users#delete', :as => :user_delete

  resource :user_session
  resource :sitemap, :only => [:show]
  resources :projects, :only => [:index]

  get '/login' => 'user_sessions#new', :as => :login
  get '/logout' => 'user_sessions#destroy', :as => :logout

  post '/upload/archive' => 'archives#create', :as => :upload_archive
  post '/upload/image' => 'images#create', :as => :upload_image

  get '/search' => 'search#advanced_search', :as => :search

  root :to => 'home#show'
  match '/:controller(/:action(/:id))', via: [:get, :post]
end
