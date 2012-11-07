class PagesController < ApplicationController
  
  respond_to :html
  
  def index
    if user_signed_in?
      @events = current_user.is_admin? ? Event.all : Event.invited(current_user)
    else
      @events = Event.public
    end
    
    # TODO: Revisit as this could get resource intensive if we have lots of events
    authorize! :read, @events.first
    respond_with @events
    
  end
end
