class GuestsController < ApplicationController
  before_filter :authenticate_user!

  include ViewModels::GuestViewModels

  load_and_authorize_resource :invitation, except: [:confirm]
  load_and_authorize_resource :guest, through: :invitation, except: [:index]

  respond_to :html, :js

  def new
    @vm = default_view_model
    respond_with @vm do |f|
      f.html { render }
      f.json { render json: @vm }
    end
  end

  def create
    @guest.role ||= 'viewer'
    ok = @guest.save
    @vm = default_view_model
    status = ok ? :ok : :unprocessable_entity

    respond_with @vm do |f|
      f.html do
        if ok
          flash[:notice] = "Guest successfully created"
          redirect_to invitation_path(@invitation)
        else
          flash[:alert] = "Unable to create guest"
          render :new, status: status
        end
      end
      f.json { render json: @vm, status: status }
    end
  end

  def update
    if params[:guest]
      # only administrators can change an invitation; guest should be destroyed from the current invitation and added to another to prevent inappropriate access
      params[:guest].delete(:invitation_id) unless current_user.is_admin?
      # A user can only be updated if it's not already the current_user; this is to prevent people from removing their own access to an invitation
      params[:guest].delete(:user_id) if @guest.user == current_user
    end

    ok = @guest.update_attributes(params[:guest])
    @vm = default_view_model
    status = ok ? :ok : :unprocessable_entity

    respond_with @vm do |f|
      f.html do
        if ok
          flash[:notice] = "Guest successfully updated"
          redirect_to invitation_path(@invitation)
        else
          flash[:alert] = "Unable to update the guest: #{@guest.errors.messages}"
          render :edit, status: status
        end
      end
      f.json { render json: @vm, status: status }
    end
  end

  def destroy
    ok = @guest.destroy
    @vm = default_view_model
    status = ok ? :ok : :unprocessable_entity

    respond_with @vm do |f|
      f.html do
        if ok
          flash[:notice] = "Guest successfully deleted"
          redirect_to invitation_path(@invitation)
        else
          flash[:alert] = "Unable to delete the guest: #{@guest.errors.messages.join(";\n")}"
          render status: status
        end
      end
      f.json { render json: @vm, status: status }
    end
  end

  def edit
    @vm = default_view_model
    respond_with @vm do |f|
      f.html { render }
      f.json { render json: @vm }
    end
  end

  def index
    load_and_authorize_guests
    @vm = default_view_model(guests: @guests)
    respond_with @vm do |f|
      f.html { render }
      f.json { render json: @vm }
    end
  end

  def show
    @vm = default_view_model
    respond_with @vm do |f|
      f.html { render }
      f.json { render json: @vm }
    end
  end

  private
  def load_and_authorize_guests
    @guests = Guest.where(invitation_id: @invitation.id)
    authorize! :read, *@guests if @guests.any?
  end

  def default_view_model(args = {})
    args = {guest: @guest, errors: @guest.errors.to_hash.merge(full_messages: @guest.errors.full_messages)} unless args && !args.empty?
    GuestViewModel.prepare(args)
  end

end
