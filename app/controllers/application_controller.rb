class ApplicationController < ActionController::Base
  protect_from_forgery
  
  rescue_from CanCan::AccessDenied do |exception|
    puts exception
    redirect_to access_denied_url, :alert => exception.message
  end
end
