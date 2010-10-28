Terse::Application.routes.draw do
  devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks" }

  resources :games,    :only => [:show]
  resources :sketches, :only => [:create]
  resources :guesses,  :only => [:create]

  match 'pusher/auth', :to => 'pushers#auth'
end
