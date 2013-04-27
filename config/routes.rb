# == Route Map (Updated 2013-04-27 11:36)
#
#        Prefix Verb   URI Pattern                  Controller#Action
# api_v1_rounds GET    /api/v1/rounds(.:format)     api/v1/rounds#index {:format=>"json"}
#               POST   /api/v1/rounds(.:format)     api/v1/rounds#create {:format=>"json"}
#  api_v1_round GET    /api/v1/rounds/:id(.:format) api/v1/rounds#show {:format=>"json"}
#               PATCH  /api/v1/rounds/:id(.:format) api/v1/rounds#update {:format=>"json"}
#               PUT    /api/v1/rounds/:id(.:format) api/v1/rounds#update {:format=>"json"}
#               DELETE /api/v1/rounds/:id(.:format) api/v1/rounds#destroy {:format=>"json"}
#  api_v1_games GET    /api/v1/games(.:format)      api/v1/games#index {:format=>"json"}
#   api_v1_game GET    /api/v1/games/:id(.:format)  api/v1/games#show {:format=>"json"}
# api_v1_arenas GET    /api/v1/arenas(.:format)     api/v1/arenas#index {:format=>"json"}
#  api_v1_arena GET    /api/v1/arenas/:id(.:format) api/v1/arenas#show {:format=>"json"}
#   api_v1_user GET    /api/v1/users/:id(.:format)  api/v1/users#show {:format=>"json"}
#           api        /api/v:api/*path(.:format)   redirect(301, /api/v1/%{path}) {:format=>"json"}
#                      /api/*path(.:format)         redirect(301, /api/v1/%{path}) {:format=>"json"}
#

PlayroundApi::Application.routes.draw do
  namespace :api, defaults: { format: 'json' } do
    namespace :v1 do
      resources :rounds, except: [:new, :edit]
      resources :games, only: [:index, :show]
      resources :arenas, only: [:index, :show]
      resources :users, only: [:show]
    end

    match 'v:api/*path', to: redirect("/api/v1/%{path}"), via: :all
    match '*path', to: redirect("/api/v1/%{path}"), via: :all
  end
end
