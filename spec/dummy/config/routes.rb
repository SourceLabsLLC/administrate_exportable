Rails.application.routes.draw do
  namespace :admin do
    resources :users, :dogs, :cats do
      get :export, on: :collection
    end

    root to: "users#index"
  end
end
