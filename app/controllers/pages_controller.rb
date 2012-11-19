class PagesController < ApplicationController
  
  respond_to :html
  
  def index
    @events = user_events
    
    # TODO: Revisit as this could get resource intensive if we have lots of events
    authorize! :read, *@events if @events.any?
      
    respond_with @events
  end
  
  def user_events
    Event.with_user(current_user)
  end
  
end
