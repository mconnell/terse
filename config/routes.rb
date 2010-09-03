Terse::Application.routes.draw do
  resources :games,    :only => [:show]
  resources :sketches, :only => [:create]

  match 'pusher/auth', :to => 'pushers#auth'
end
