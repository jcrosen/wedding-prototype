class PagesController < ApplicationController
  include ViewModels::InvitationViewModels
  
  respond_to :html
  
  def index
    @vm = InvitationViewModel.prepare()
      
    respond_with @vm
  end
  
  private
  #TODO: Make this in some way a configurable item with transparency outside of the controller
  def user_events(size = 3)
    Event.with_user(current_user).limit(size)
  end
  
  def user_posts(size = 3)
    Post.with_viewer(current_user).recent
  end

  def user_invitations
    Invitation.with_user(current_user)
  end
  
end
