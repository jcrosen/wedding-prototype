class EventsController < ApplicationController
  before_filter :new_event, only: [ :new ]
  before_filter :load_event, only: [ :show, :edit, :update, :destroy ]
  before_filter :load_events, only: [ :index ]
  before_filter :create_event, only: [ :create ]
  before_filter :update_event, only: [ :update ]
  before_filter :destroy_event, only: [ :destroy ]
  
  respond_to :html, :json
  
  def index
    respond_with @events do |format|
      format.html { render }
      format.json { render json: @events }
    end
  end
  
  def show
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
    if user_signed_in?
      @events = Event.invited(current_user)
    else
      @events = Event.public
    end
  end
  
end
