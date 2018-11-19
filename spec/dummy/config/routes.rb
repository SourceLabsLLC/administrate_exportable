Rails.application.routes.draw do
  namespace :admin do
    resources :users, :dogs do
      get :export, on: :collection
    end
  end
end
