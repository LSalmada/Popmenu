Rails.application.routes.draw do
  get "up" => "rails/health#show", :as => :rails_health_check

  namespace :api do
    namespace :v1 do
      resources :restaurants do
        resources :menus, only: [:index, :create]
      end

      resources :menu_items, only: [:index, :create]
    end
  end
end
