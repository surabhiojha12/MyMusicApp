Rails.application.routes.draw do
  resources :songs do
    collection do  #creates end point '/songs/search'
      post :search, to: 'songs#search'
      post :addedsongs, to: 'songs#addedsongs'
    end
  end
  
  get 'sessions/new'

  resources :users, :except => [:index, :edit, :update, :show]
  resources :sessions, :only => [:new, :create, :destroy]

  get '/users/profile', to: 'users#show'
  root to: 'songs#index'

  get '/signin', to: 'sessions#new'
  delete '/signout', to: 'sessions#destroy'
  get '/signup', to: 'users#new'
  
  
  post '/playlists/:playlist_id', to: 'playlist_song#show', as: :show_playlist_songs
  get '/playlists/:playlist_id/songs/:song_id/', to:'playlist_song#add' , as: :add_to_playlist
  
  scope controller: :playlists do
    delete '/playlists/:id' => :destroy, as: :delete_playlist
    post '/playlists' => :create, as: :create_playlist
    get '/playlists' => :show, as: :show_playlist
    post '/playlists/songs/:song_id' => :show, as: :show_playlist_add
    post '/search_playlist'=> :search
    get '/playlists/new' => :new
  end



  #resources :playlists 
  #get '*path' => redirect('/404.html') #this should be the end
  
  
 # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
