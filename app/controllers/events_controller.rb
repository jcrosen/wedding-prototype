class EventsController < ApplicationController

  include ViewModels::InvitationViewModels

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
    
    respond_with @event, @ivm do |format|
      format.html { render }
      format.json { render json: @event }
    end
  end
  
  private
  def load_event
    @event = Event.find(params[:id])
    load_invitation
  end
  
  def load_events
    @events = Event.with_user(current_user)
  end

  def load_invitation
    invitation = @event.invitations.with_user(current_user).first()
    @ivm = InvitationViewModel.prepare(invitation: invitation)
  end
  
end
