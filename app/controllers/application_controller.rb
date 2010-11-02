class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :authenticate_user!
  before_filter :set_user_id

  def set_user_id
    session[:user_id] ||= Time.now.to_i
  end

end
