Rails.application.routes.draw do
  namespace :admin do
    resources :users do
      get :export, on: :collection
    end
  end
end
