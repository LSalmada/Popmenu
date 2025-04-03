Rails.application.routes.draw do
  get "up" => "rails/health#show", :as => :rails_health_check

  namespace :api do
    namespace :v1 do
      resources :restaurants do
        resources :menus, shallow: true
        post "import", on: :collection
      end

      resources :menu_items
    end
  end
end
