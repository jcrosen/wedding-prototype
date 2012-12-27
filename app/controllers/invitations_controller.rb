class InvitationsController < ApplicationController
  include ViewModels::InvitationViewModels

  respond_to :html, :js

  before_filter :load_invitation, only: [ :show, :edit, :update, :destroy, :confirm ]
  before_filter :load_invitations, only: [ :index ]
  
  respond_to :html, :json
  
  def index
    authorize! :read, *@invitations if @invitations.any?
    @vm = InvitationViewModel.prepare(invitations: @invitations)
    
    respond_with @vm do |format|
      format.html { render }
      format.json { render json: @vm.marshal_dump }
    end
  end
  
  def show
    authorize! :read, @invitation
    @vm = InvitationViewModel.prepare(invitation: @invitation)
    
    respond_with @vm do |format|
      format.html { render }
      format.json { render json: @vm.marshal_dump }
    end
  end

  def confirm
    authorize! :confirm, @invitation

    ok = @invitation.confirm!(status: params[:status])
    @vm = InvitationViewModel.prepare(invitation: @invitation)

    respond_with @vm do |format|
      format.html {
        if ok
          flash[:notice] = "Invitation confirmed"  #TODO: Move this into YAML
        else
          flash[:alert] = "Error confirming invitation. Please try again or contact the administrator"
        end

        redirect_to invitation_path(@vm.invitation)
      }
      format.json { render json: @vm.marshal_dump }
    end

  end
  
  private
  def load_invitation
    @invitation = Invitation.find(params[:id])
  end
  
  def load_invitations
    @invitations = Invitation.with_user(current_user)
  end
end
