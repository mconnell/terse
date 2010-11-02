Terse::Application.routes.draw do
  devise_for :users

  resources :games,    :only => [:show]
  resources :sketches, :only => [:create]
  resources :guesses,  :only => [:create]

end
