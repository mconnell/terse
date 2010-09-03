class SketchesController < ApplicationController

  def create
    params['paths'] = params.delete('path').map{|path| path.split(',')} if params['path']
    Pusher["private-game-#{params['game_id']}"].trigger('push', params)
    render :text => 'ok'
  end

end
