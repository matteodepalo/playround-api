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
