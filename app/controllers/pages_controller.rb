class PagesController < ApplicationController
  include ViewModels::InvitationViewModels
  respond_to :html

  def index
    @vm = InvitationViewModel.prepare()
    respond_with @vm
  end

  def lodging
    respond_with nil
  end

  def contact
    respond_with nil
  end

  def transportation
    respond_with nil
  end
end
