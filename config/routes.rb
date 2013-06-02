# == Route Map (Updated 2013-05-29 14:33)
#
#                  Prefix Verb   URI Pattern                                   Controller#Action
# v1_round_participations DELETE /v1/rounds/:round_id/participations(.:format) v1/participations#destroy
#                         POST   /v1/rounds/:round_id/participations(.:format) v1/participations#create
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
#             me_v1_users GET    /v1/users/me(.:format)                        v1/users#me
#                 v1_user GET    /v1/users/:id(.:format)                       v1/users#show
#               v1_tokens POST   /v1/tokens(.:format)                          v1/tokens#create
#                      v1        /v1/*a(.:format)                              #<Proc:0x007ffdeec297e8@/vagrant/config/routes.rb:25 (lambda)>
#                                /v:api/*path(.:format)                        redirect(301)
#                                /*path(.:format)                              redirect(301)
#                    root GET    /                                             #<Proc:0x007ffdeec297e8@/vagrant/config/routes.rb:25 (lambda)>
#

not_found = -> (params) { raise ActionController::RoutingError.new("No route matches [#{params['REQUEST_METHOD']}] \"#{params['REQUEST_PATH']}\"") }

PlayroundApi::Application.routes.draw do
  namespace :v1 do
    resources :rounds, except: [:new, :edit] do
      resources :participations, only: [:create] do
        collection { delete :destroy }
      end
    end

    resources :games, only: [:index, :show]
    resources :arenas, only: [:index, :show]

    resources :users, only: [:show]

    resources :tokens, only: [:create]

    match '*a', to: not_found, via: :all
  end

  match 'v:api/*path', to: redirect { |params| "/v1/#{params[:path]}" }, via: :all
  match '*path', to: redirect { |params| "/v1/#{params[:path]}" }, via: :all

  root to: not_found
end
