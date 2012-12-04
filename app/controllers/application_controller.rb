class ApplicationController < ActionController::Base
  protect_from_forgery
  
  rescue_from CanCan::AccessDenied do |exception|
    puts exception
    # Must reference main_app here due to a rails_admin routing quirk
    redirect_to main_app.root_path, alert: exception.message
  end
  
end
