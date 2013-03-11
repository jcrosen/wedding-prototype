class PagesController < ApplicationController
  include ViewModels::InvitationViewModels
  respond_to :html

  def index
    @vm = InvitationViewModel.prepare()
    respond_with @vm
  end

end
