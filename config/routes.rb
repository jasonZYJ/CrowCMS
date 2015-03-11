Rails.application.routes.draw do

  root to: 'admin/home#index'

  devise_for :users, 
             controllers: { sessions: "users/sessions" }, 
             path: "", 
             path_names: { sign_in: 'login', sign_out: 'logout', registration: 'register' }

  mount Ckeditor::Engine => '/ckeditor'
  
  namespace :admin do
  #article module
    resources :categories, path: 'category', except: :new do
        #add a category under super category.
        get 'new', to: 'categories#new', 
                   on: :member, 
                   as: :new, 
                   :constraints => { :parent_id => /\d/ }
    end

    resources :articles, path: 'article' do
        #reload article elements when categroy select changed.
        get 'concat', to: 'articles#article_concat', on: :collection
    end
    resources :article_options, path: 'article-option'
    resources :article_pictures, path: 'article-picture', only: [:create, :destroy] do
      #show pictures belongs specificy article.
      get '',  to: 'article_pictures#index', 
               as: :picture_by, 
               :constraints => { :article_id => /\d/ },
               on: :member  
    end
  #album module
    resources :album_tags, path: 'album-tags'
    resources :albums
    resources :photos, except: :new do
      get 'new', to: 'photos#new', 
                 as: :photo_new, 
                 :constraints => { :parent_id => /\d|nil/ },
                 on: :member
    end

  #page module
    resources :pages, path: 'page'
    
  #trash module
    namespace :trash do
      #for article
      resources :articles, path: 'article', only: [:index, :destroy] do
        put 'restore', to: 'articles#restore', on: :member
      end
      #for pages
      resources :pages, path: 'page', only: [:index, :destroy] do
        put 'restore', to: 'pages#restore', on: :member
      end
    end
    #end trash namespae
    
    #message module
    resources :messages, path: 'message' do
      put 'review', to: 'messages#review', on: :member
    end

  end 
  #end admin namespace


end
