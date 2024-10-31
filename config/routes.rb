Rails.application.routes.draw do
  # root to: "home#index"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  devise_for :users, skip: %i[sessions registrations passwords confirmations]
  # as is an alias for devise_scope
  as :user do
    post "api/v1/sign_up", to: "users/registrations#create", as: :user_registration
    get "api/v1/sign_in", to: "users/sessions#new", as: :new_user_registration_path # redirects to web app
    post "api/v1/sign_in", to: "users/sessions#create", as: :user_session
    # We don't skip and name this route because we use the Devise web component of password resetting
    get "users/password/new", to: "users/passwords#new", as: :new_user_password
    get "users/password/success", to: "users/passwords#reset_success", as: :reset_password_success
    post "users/password", to: "users/passwords#create", as: :user_password
    get "users/password/edit", to: "users/passwords#edit", as: :edit_user_password
    put "users/password", to: "users/passwords#update"

    post "api/password", to: "users/passwords#create"
    match "api/v1/sign_out", to: "users/sessions#destroy", as: :destroy_user_session, via: %i[get delete]
    match "api/:user_id/sign_out", to: "users/sessions#destroy", as: :destroy_user_session_with_user_id, via: %i[get delete]

    get "users/confirmation/new", to: "users/confirmations#new", as: :new_user_confirmation
    get "users/confirmation", to: "users/confirmations#show", as: :user_confirmation
    post "users/confirmation", to: "users/confirmations#create"
    get "users/confirmed", to: "users/confirmations#confirmed", as: :user_confirmed
    get "users/confirmation_resent", to: "users/confirmations#confirmation_resent", as: :user_confirmation_resent
  end

  scope :api do
    # /api/v1/...
    scope :v1 do
      # /api/v1/companies/{company_id}/...
      # /api/v1{user_id}/...
      scope "/:user_id" do
        # /api/v1/{user_id}/companies/{company_id}/...
        resources :companies, only: [] do
          get :tabs, to: "api/v1/users#tabs"
          resources :roles, controller: "api/v1/roles", only: [:index, :create, :update, :destroy]
          resources :users, controller: "api/v1/users", only: [:index, :update, :destroy]
          resources :estimates, controller: "api/v1/estimates", only: %i[index create update destroy]
          resources :invoices, controller: "api/v1/invoices", only: %i[index create update destroy]
          resource :settings, controller: "api/v1/settings", only: %i[show update]
        end
      end
    end
  end
end

