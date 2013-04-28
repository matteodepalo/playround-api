# == Route Map (Updated 2013-04-28 10:42)
#
#    Prefix Verb   URI Pattern              Controller#Action
# v1_rounds GET    /v1/rounds(.:format)     v1/rounds#index
#           POST   /v1/rounds(.:format)     v1/rounds#create
#  v1_round GET    /v1/rounds/:id(.:format) v1/rounds#show
#           PATCH  /v1/rounds/:id(.:format) v1/rounds#update
#           PUT    /v1/rounds/:id(.:format) v1/rounds#update
#           DELETE /v1/rounds/:id(.:format) v1/rounds#destroy
#  v1_games GET    /v1/games(.:format)      v1/games#index
#   v1_game GET    /v1/games/:id(.:format)  v1/games#show
# v1_arenas GET    /v1/arenas(.:format)     v1/arenas#index
#  v1_arena GET    /v1/arenas/:id(.:format) v1/arenas#show
#   v1_user GET    /v1/users/:id(.:format)  v1/users#show
#                  /v:api/*path(.:format)   redirect(301, /v1/%{path})
#                  /*path(.:format)         redirect(301, /v1/%{path})
#      root GET    /                        #<Proc:0x007f9852b942d0@/vagrant/config/routes.rb:31 (lambda)>
#

PlayroundApi::Application.routes.draw do
  namespace :v1 do
    resources :rounds, except: [:new, :edit]
    resources :games, only: [:index, :show]
    resources :arenas, only: [:index, :show]
    resources :users, only: [:show] do
      collection { get :me }
    end
  end

  match 'v:api/*path', to: redirect("/v1/%{path}"), via: :all
  match '*path', to: redirect("/v1/%{path}"), via: :all

  root to: -> (app) { [404, {}, ['']] }
end
