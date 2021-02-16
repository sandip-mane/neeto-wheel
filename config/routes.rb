# frozen_string_literal: true

require "sidekiq/web"

Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      namespace :server do
        resources :organizations, only: [:create]
        resource :profile, only: [:update]
        resource :change_email, only: [:update]
      end
    end
  end

  devise_scope :user do
    get 'login', to: 'users/sessions#new'
    get 'logout', controller: 'users/sessions', action: 'destroy', as: :logout
  end

  namespace :auth do
    resource :profile, only: [:edit]
    resource :change_password, only: [:new]
    resource :change_email, only: [:new]

    get :chain, to: 'chain_authentications#index'
  end

  devise_for :users, path_prefix: "devise", controllers: { registrations: "registrations" }

  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      devise_scope :user do
        post "login" => "sessions#create", as: "login"
        delete "logout" => "sessions#destroy", as: "logout"
      end

      resources :users, only: [:show, :create, :update, :destroy], constraints: { id: /.*/ }
      resources :notes, only: [:index, :create] do
        collection do
          post 'bulk_delete'
        end
      end
    end
  end

  root "home#index"
  get "*path", to: "home#index", via: :all
end