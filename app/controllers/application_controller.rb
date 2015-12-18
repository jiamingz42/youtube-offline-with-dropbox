class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_filter :authenticate

  private
  def authenticate
    if params[:service_key] != ENV['MY_SERVICE_KEY']
      render :text => 'Unauthorized user'
    end
  end

end
