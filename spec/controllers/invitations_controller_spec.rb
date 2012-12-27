require 'spec_helper'

describe InvitationsController do

  def create_invitations(size, _user = nil)
    args = {}
    args.merge(user_id: _user.id) unless _user.nil?

    size.times { |n| Factory.create(:invitation, args) }
    Invitation.all
  end
  
  let(:user) { login_user }
  let(:invitations) { create_invitations(5, user) }
  let(:invitation) { Factory.create(:invitation) }
  let(:invitation_user) { Factory.create(:invitation_user, user_id: user.id, invitation_id: invitation.id, role: "owner") }

  describe "#index" do
    before do
      invitations
      get :index, format: :html
    end
    
    it { should respond_with(:success) }
    it { should assign_to(:invitations) }
  end

  describe "#show" do
    before do
      invitation_user
      get :show, format: :html, id: invitation.id
    end
    
    it { should respond_with(:success) }
    it { should assign_to(:invitation).with(invitation) }
  end

  describe "#confirm" do
    before do
      invitation_user
    end

    context "with correct paramters" do
      before do
        put :confirm, format: :html, id: invitation.id, status: :attending
      end

      it { should redirect_to invitation_path }
      it { should set_the_flash[:notice] }
    end

    context "with incorrect paramters" do
      before do
        put :confirm, format: :html, id: invitation.id
      end

      it { should redirect_to invitation_path }
      it { should set_the_flash[:alert] }
    end
  end

end