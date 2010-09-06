class PushersController < ApplicationController
  skip_before_filter :verify_authenticity_token

  def auth
    response = Pusher[params[:channel_name]].authenticate(params[:socket_id], {:user_id => session[:user_id]})
    render :json => response
  end

end