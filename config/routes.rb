Rails.application.routes.draw do
  devise_for :users

  get "up" => "rails/health#show", as: :rails_health_check

  root "comics#index"

  # Grape API routes
  mount V1::Comics::Get => "/"
  mount V1::Comics::Character::Get => "/"
end
