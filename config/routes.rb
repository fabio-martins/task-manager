Rails.application.routes.draw do
  # Mount Action Cable server
  mount ActionCable.server => "/cable"

  devise_for :users

  root "tasks#index"

  resources :tasks do
    resources :comments, only: [ :create, :destroy ]
    get :calendar, on: :collection
    collection do
      post :generate_description
    end
  end
end
