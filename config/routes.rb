Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check

  resources :slack , except: %i[index show create new update destroy edit ] do
    collection do
      post :interactions
    end
  end

  # post "slack/interactions"

  # Defines the root path route ("/")
  # root "posts#index"
end
