require 'spec_helper'

module ControllerMacros
  def create_admin
    user = Factory.create(:user)
    user.make_admin
    user.save
    user
  end
  
  def login_admin(user = nil)
    @request.env["devise.mapping"] = Devise.mappings[:admin]
    if !(user && user.is_admin?)
      user = create_admin
    end
    
    sign_in user
    user
  end

  def login_user(user = nil)
    @request.env["devise.mapping"] = Devise.mappings[:user]
    if !user
      user = Factory.create(:user)
    end
    
    sign_in user
    user
  end
end