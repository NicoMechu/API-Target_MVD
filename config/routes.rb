# encoding: utf-8

Railsroot::Application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  devise_for :users, path: 'api/v1/users/', controllers: {
    sessions: 'api/v1/sessions',
    registrations: 'api/v1/registrations',
    passwords: 'api/v1/passwords'
  }

  root 'api/v1/api#status'

  namespace :api, defaults: { format: :json }  do
    namespace :v1 do
      resources :users, only: [:update] do
        get  'unread_conversations'
        put '/password/change', action: :change_password
        resources :targets
        resources :push_tokens, only: [:create]
        resources :match_conversations do
          post 'close'
          resources :messages, only: [:create, :index]
        end
      end
      resources :topics, only: [:index]
    end
  end
  resources :home, only: [:index]
end
