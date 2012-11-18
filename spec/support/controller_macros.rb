require 'spec_helper'

module ControllerMacros
  def login_admin
    @request.env["devise.mapping"] = Devise.mappings[:admin]
    user = Factory.create(:user)
    user.make_admin
    user.save
    sign_in user
    user
  end

  def login_user
    @request.env["devise.mapping"] = Devise.mappings[:user]
    user = Factory.create(:user)
    sign_in user
    user
  end
end