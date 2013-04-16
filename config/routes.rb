PlayroundApi::Application.routes.draw do
  scope :api do
    namespace :v1 do
      resources :rounds, :except => [:new, :edit]
    end

    get 'v:api/*path', to: redirect("/api/v1/%{path}"), via: :all
    get '*path', to: redirect("/api/v1/%{path}"), via: :all
  end
end
