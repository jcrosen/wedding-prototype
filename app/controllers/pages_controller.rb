class PagesController < ApplicationController
  
  respond_to :html
  
  def index
    @events = user_events
    @posts = user_posts
    
    # TODO: Revisit as this could get resource intensive if we have lots of events
    authorize! :read, *@events if @events.any?
      
    respond_with @events
  end
  
  private
  #TODO: Make this in some way a configurable item with transparency outside of the controller
  def user_events(size = 3)
    Event.with_user(current_user).limit(size)
  end
  
  def user_posts(size = 3)
    Post.with_viewer(current_user).recent
  end
  
end
