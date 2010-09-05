class SketchesController < ApplicationController

  def create
    socket_id       = params.delete('socket_id')
    params['paths'] = params.delete('path').map{|path| path.split(',')} if params['path']
    Pusher["presence-game-#{params['game_id']}"].trigger('push', params, socket_id)
    render :text => 'ok'
  end

end
