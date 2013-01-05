class GuestsController < ApplicationController
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

  end

  def update
  end

  def destroy
    ok = @guest.destroy
    respond_with @guest do |f|
      f.html do
        if ok
          redirect_to invitation_path(@invitation)
        else
          flash[:alert] = "Unable to delete the guest: #{@guest.errors}"
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

  def confirm
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
