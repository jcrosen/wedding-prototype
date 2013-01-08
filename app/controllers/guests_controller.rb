class GuestsController < ApplicationController
  before_filter :authenticate_user!

  load_and_authorize_resource :invitation, except: [:confirm]
  load_and_authorize_resource :guest, through: :invitation, except: [:index]

  respond_to :html, :js

  def new
    respond_with @guest do |f|
      f.html { render }
      f.json { render json: @guest }
    end
  end

  def create
    authorize! :create, @guest
    ok = @guest.save

    respond_with @guest do |f|
      f.html do
        if ok
          flash[:notice] = "Guest successfully create"
          redirect_to invitation_path(@invitation)
        else
          flash[:alert] = "Unable to create guest"
          render
        end
      end
      f.json { render json: @guest }
    end
  end

  def update
    if params[:guest]
      # only administrators can change an invitation; guest should be destroyed from the current invitation and added to another to prevent in appropriate access
      params[:guest].delete(:invitation_id) unless current_user.is_admin?
      # A user can only be updated if it's not already the current_user; this is to prevent people from removing their own access to an invitation
      params[:guest].delete(:user_id) if @guest.user == current_user
    end

    ok = @guest.update_attributes(params[:guest])

    respond_with @guest do |f|
      f.html do
        if ok
          flash[:notice] = "Guest successfully updated"
          redirect_to invitation_path(@invitation)
        else
          flash[:alert] = "Unable to update the guest: #{@guest.errors.messages}"
          render
        end
      end
      f.json { render json: @guest }
    end
  end

  def destroy
    ok = @guest.destroy

    respond_with @guest do |f|
      f.html do
        if ok
          flash[:notice] = "Guest successfully deleted"
          redirect_to invitation_path(@invitation)
        else
          flash[:alert] = "Unable to delete the guest: #{@guest.errors.messages.join(";\n")}"
          render
        end
      end
      f.json { render json: @guest }
    end
  end

  def edit
    respond_with @guest do |f|
      f.html { render }
      f.json { render json: @guest }
    end
  end

  def index
    load_and_authorize_guests

    respond_with @guests do |f|
      f.html { render }
      f.json { render json: @guests }
    end
  end

  def show
    respond_with @guest do |f|
      f.html { render }
      f.json { render json: @guest }
    end
  end

  private
  def load_and_authorize_guests
    @guests = Guest.where(invitation_id: @invitation.id)
    authorize! :read, *@guests if @guests.any?
  end

end
