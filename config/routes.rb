Rails.application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

  devise_for :users

  authenticated :user do
    root to: 'organizations#index', as: :authenticated_root
  end

  devise_scope :user do
    root to: 'devise/sessions#new', as: :unauthenticated_root
  end

  resources :organizations do 
    member do
      post :switch
      get :analytics
    end 
    collection do
      delete :leave
    end
    resources :rule_sets
    resources :memberships, only: [:index, :create, :destroy]
    resources :spaces do 
      member do
        post :join
        delete :leave
      end
      resources :posts
    end
  end
end
