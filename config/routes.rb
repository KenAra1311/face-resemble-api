Rails.application.routes.draw do
  namespace :v1 do
    resources :users
    resources :posts
    resources :likes
    resources :follows
    resources :comments
  end
end
