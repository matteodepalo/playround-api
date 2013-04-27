PlayroundApi::Application.routes.draw do
  namespace :api, defaults: { format: 'json' } do
    namespace :v1 do
      resources :rounds, except: [:new, :edit]
      resources :games, except: [:new, :edit]
      resources :arenas, except: [:new, :edit]
    end

    match 'v:api/*path', to: redirect("/api/v1/%{path}"), via: :all
    match '*path', to: redirect("/api/v1/%{path}"), via: :all
  end
end
#== Route Map
# Generated on 27 Apr 2013 11:02
#
# api_v1_rounds GET    /api/v1/rounds(.:format)     api/v1/rounds#index {:format=>"json"}
#               POST   /api/v1/rounds(.:format)     api/v1/rounds#create {:format=>"json"}
#  api_v1_round GET    /api/v1/rounds/:id(.:format) api/v1/rounds#show {:format=>"json"}
#               PATCH  /api/v1/rounds/:id(.:format) api/v1/rounds#update {:format=>"json"}
#               PUT    /api/v1/rounds/:id(.:format) api/v1/rounds#update {:format=>"json"}
#               DELETE /api/v1/rounds/:id(.:format) api/v1/rounds#destroy {:format=>"json"}
#  api_v1_games GET    /api/v1/games(.:format)      api/v1/games#index {:format=>"json"}
#               POST   /api/v1/games(.:format)      api/v1/games#create {:format=>"json"}
#   api_v1_game GET    /api/v1/games/:id(.:format)  api/v1/games#show {:format=>"json"}
#               PATCH  /api/v1/games/:id(.:format)  api/v1/games#update {:format=>"json"}
#               PUT    /api/v1/games/:id(.:format)  api/v1/games#update {:format=>"json"}
#               DELETE /api/v1/games/:id(.:format)  api/v1/games#destroy {:format=>"json"}
# api_v1_arenas GET    /api/v1/arenas(.:format)     api/v1/arenas#index {:format=>"json"}
#               POST   /api/v1/arenas(.:format)     api/v1/arenas#create {:format=>"json"}
#  api_v1_arena GET    /api/v1/arenas/:id(.:format) api/v1/arenas#show {:format=>"json"}
#               PATCH  /api/v1/arenas/:id(.:format) api/v1/arenas#update {:format=>"json"}
#               PUT    /api/v1/arenas/:id(.:format) api/v1/arenas#update {:format=>"json"}
#               DELETE /api/v1/arenas/:id(.:format) api/v1/arenas#destroy {:format=>"json"}
#           api        /api/v:api/*path(.:format)   redirect(301, /api/v1/%{path}) {:format=>"json"}
#                      /api/*path(.:format)         redirect(301, /api/v1/%{path}) {:format=>"json"}
