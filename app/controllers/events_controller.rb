class EventsController < ApplicationController
  respond_to :html, :js

  before_filter :load_event, only: [ :show, :edit, :update, :destroy ]
  before_filter :load_events, only: [ :index ]
  
  respond_to :html, :json
  
  def index
    authorize! :read, *@events if @events.any?
    
    respond_with @events do |format|
      format.html { render }
      format.json { render json: @events }
    end
  end
  
  def show
    authorize! :read, @event
    
    respond_with @event do |format|
      format.html { render }
      format.json { render json: @event }
    end
  end
  
  private
  def load_event
    @event = Event.find(params[:id])
  end
  
  def load_events
    @events = Event.with_user(current_user)
  end
  
end
