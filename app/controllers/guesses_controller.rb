class GuessesController < ApplicationController

  def create
    socket_id = params.delete('socket_id')
    Pusher["presence-game-#{params['game_id']}"].trigger('guess', params)
    render :text => 'ok'
  end

end