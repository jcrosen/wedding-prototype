class InvitationsController < ApplicationController
  before_filter :authenticate_user!
  before_filter 

  include ViewModels::InvitationViewModels

  respond_to :html, :js

  before_filter :load_invitation, only: [ :show, :edit, :update, :destroy, :confirm ]
  before_filter :load_invitations, only: [ :index ]
  
  respond_to :html, :json
  
  def index
    authorize! :read, *@invitations if @invitations.any?
    @vm = default_view_model(invitations: @invitations)
    respond_with @vm do |f|
      f.html { render html: @vm }
      f.json { render json: @vm }
    end
  end
  
  def show
    authorize! :read, @invitation
    @vm = default_view_model
    respond_with @vm do |f|
      f.html { render }
      f.json { render json: @vm }
    end
  end

  def confirm
    authorize! :confirm, @invitation
    ok = @invitation.confirm!(status: params[:status])
    @vm = default_view_model
    status = ok ? :ok : :unprocessable_entity

    respond_with @vm do |format|
      format.html do
        if ok
          flash[:notice] = "Invitation confirmed"  #TODO: Move this into YAML?
        else
          flash[:alert] = "Error confirming invitation. Please try again or contact the administrator"
        end
        redirect_to invitation_path(@vm.invitation)
      end
      format.json { render json: @vm, status: status }
    end

  end
  
  private
  def load_invitation
    @invitation = Invitation.find(params[:id])
    @invitation.current_user = current_user
  end
  
  def load_invitations
    @invitations = Invitation.with_user(current_user)
    @invitations.each { |i| i.current_user = current_user }
  end

  def default_view_model(args = {})
    args = { invitation: @invitation, errors: @invitation.errors } unless args && !args.empty?
    InvitationViewModel.prepare(args)
  end
end
