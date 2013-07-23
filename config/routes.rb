# == Route Map (Updated 2013-07-23 13:06)
#
#                  Prefix Verb   URI Pattern                                   Controller#Action
# v1_round_participations DELETE /v1/rounds/:round_id/participations(.:format) v1/participations#destroy
#                         POST   /v1/rounds/:round_id/participations(.:format) v1/participations#create
#         v1_round_starts POST   /v1/rounds/:round_id/starts(.:format)         v1/starts#create
#       v1_round_winnings POST   /v1/rounds/:round_id/winnings(.:format)       v1/winnings#create
#               v1_rounds GET    /v1/rounds(.:format)                          v1/rounds#index
#                         POST   /v1/rounds(.:format)                          v1/rounds#create
#                v1_round GET    /v1/rounds/:id(.:format)                      v1/rounds#show
#                         PATCH  /v1/rounds/:id(.:format)                      v1/rounds#update
#                         PUT    /v1/rounds/:id(.:format)                      v1/rounds#update
#                         DELETE /v1/rounds/:id(.:format)                      v1/rounds#destroy
#                v1_games GET    /v1/games(.:format)                           v1/games#index
#                 v1_game GET    /v1/games/:id(.:format)                       v1/games#show
#               v1_arenas GET    /v1/arenas(.:format)                          v1/arenas#index
#                v1_arena GET    /v1/arenas/:id(.:format)                      v1/arenas#show
#         v1_user_buddies GET    /v1/users/:user_id/buddies(.:format)          v1/buddies#index
#      v1_user_buddyships POST   /v1/users/:user_id/buddyships(.:format)       v1/buddyships#create
#                 v1_user GET    /v1/users/:id(.:format)                       v1/users#show
#               v1_tokens POST   /v1/tokens(.:format)                          v1/tokens#create
#                      v1        /v1/*a(.:format)                              #<Proc:0x007f1c4b6ff680@/vagrant/config/routes.rb:27 (lambda)>
#                                /v:api/*path(.:format)                        redirect(301)
#                                /*path(.:format)                              redirect(301)
#                    root GET    /                                             #<Proc:0x007f1c4b6ff680@/vagrant/config/routes.rb:27 (lambda)>
#

not_found = -> (params) { raise ActionController::RoutingError.new("No route matches [#{params['REQUEST_METHOD']}] \"#{params['REQUEST_PATH']}\"") }

PlayroundApi::Application.routes.draw do
  namespace :v1 do
    resources :rounds, except: [:new, :edit] do
      resources :participations, only: [:create, :destroy]
      resources :starts, only: :create
      resources :winnings, only: :create
    end

    resources :games, only: [:index, :show]
    resources :arenas, only: [:index, :show]

    resources :users, only: :show do
      resources :buddies, only: :index
      resources :buddyships, only: :create
    end

    resources :tokens, only: :create

    match '*a', to: not_found, via: :all
  end

  match 'v:api/*path', to: redirect { |params| "/v1/#{params[:path]}" }, via: :all
  match '*path', to: redirect { |params| "/v1/#{params[:path]}" }, via: :all

  root to: not_found
end
