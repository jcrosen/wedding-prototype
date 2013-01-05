require "spec_helper"
require "cancan/matchers"

describe User do
  
  def create_admin
    user = Factory.create(:user)
    user.make_admin
    user.save
    return user
  end
  
  describe "Abilities" do
    let(:ability) { Ability.new(user) }
    let(:public_event) { Factory.create(:event, is_public: true) }
    let(:private_event) { Factory.create(:event) }
    let(:global_post) { Factory.create(:post, postable: nil) }
    let(:public_event_post) { Factory.create(:post, postable: public_event) }
    let(:private_event_post) { Factory.create(:post, postable: private_event) }
    
    subject { ability }
    
    context "when no user is logged in" do
      let(:user) { nil }
      let(:invitation) { Factory.create(:invitation) }
      let(:guest) { Factory.create(:invitation) }
      
      # Cannot access any invitations
      it { should_not be_able_to(:read, Invitation) }
      it { should_not be_able_to(:read, invitation) }
      it { should_not be_able_to(:create, Invitation) }
      it { should_not be_able_to(:update, invitation) }
      it { should_not be_able_to(:destroy, invitation) }
      it { should_not be_able_to(:confirm, invitation) }

      # Cannot access any guests
      it { should_not be_able_to(:read, Guest) }
      it { should_not be_able_to(:read, guest) }
      it { should_not be_able_to(:create, Guest) }
      it { should_not be_able_to(:update, guest) }
      it { should_not be_able_to(:destroy, guest) }
      
      # Can access public events
      it { should be_able_to(:read, public_event) }
      it { should_not be_able_to(:create, Event) }
      it { should_not be_able_to(:update, public_event) }
      it { should_not be_able_to(:destroy, public_event) }
      
      # Can access global posts
      it { should be_able_to(:read, global_post) }
      it { should be_able_to(:read, public_event_post) }
      it { should be_able_to(:read, *[global_post, public_event_post]) }
      it { should_not be_able_to(:read, private_event_post) }
      it { should_not be_able_to(:create, Post) }
      it { should_not be_able_to(:update, global_post) }
      it { should_not be_able_to(:update, public_event_post) }
      it { should_not be_able_to(:update, private_event_post) }
      it { should_not be_able_to(:destroy, global_post) }
      it { should_not be_able_to(:destroy, public_event_post) }
      it { should_not be_able_to(:destroy, private_event_post) }
    end
    
    context "when an admin is logged in" do
      let(:user) { create_admin }
      
      it { should be_able_to(:manage, Event) }
      it { should be_able_to(:manage, Invitation) }
      it { should be_able_to(:manage, Post) }
      it { should be_able_to(:manage, Guest)}
    end
    
    context "when a non-admin user is logged in" do
      let(:user) { Factory.create(:user) }
      let(:other_event) { Factory.create(:event) }
      let(:invitation) { Factory.create(:invitation, event_id: private_event.id) }
      let(:guest) { Factory.create(:guest, user_id: user.id, invitation_id: invitation.id, role: "owner") }
      let(:second_guest) { Factory.create(:guest, invitation_id: invitation.id, role: "reader") }
      let(:new_guest) { Factory.build(:guest, invitation_id: invitation.id, role: "reader") }
      let(:other_invitation) { Factory.create(:invitation, event_id: other_event.id) }
      let(:other_guest) { Factory.create(:guest, invitation_id: other_invitation.id, role: "owner") }
      let(:other_event_post) { Factory.create(:post, postable: other_event) }
      let(:other_new_guest) { Factory.build(:guest, invitation_id: other_invitation.id, role: "reader") }
      
      # Need to ensure that the invitations are created before we check the event permissions below in single line it blocks
      before :each do
        guest
        other_guest
      end
      
      # Invitations
      it { should be_able_to(:read, invitation) }
      it { should be_able_to(:confirm, invitation) }
      it { should_not be_able_to(:update, invitation) }
      it { should_not be_able_to(:destroy, invitation) }
      it { should_not be_able_to(:create, Invitation) }

      # Guests
      it { should be_able_to(:read, guest) }
      it { should be_able_to(:create, Guest) }
      it { should be_able_to(:create, new_guest) }
      it { should be_able_to(:update, guest) }
      it { should be_able_to(:update, second_guest) }
      it { should be_able_to(:destroy, second_guest) }

      it { should_not be_able_to(:read, other_guest) }
      it { should_not be_able_to(:create, other_new_guest) }
      it { should_not be_able_to(:update, other_guest) }
      it { should_not be_able_to(:destroy, other_guest) }
      
      # Events
      it { should be_able_to(:read, public_event) }
      it { should be_able_to(:read, private_event) }
      it { should be_able_to(:read, *[public_event, private_event]) }
      it { should_not be_able_to(:read, other_event) }
      it { should_not be_able_to(:create, Event) }
      it { should_not be_able_to(:update, Event) }
      it { should_not be_able_to(:destroy, Event) }
      
      # Posts
      it { should be_able_to(:read, global_post) }
      it { should be_able_to(:read, public_event_post) }
      it { should be_able_to(:read, private_event_post) }
      it { should be_able_to(:read, *[global_post, public_event_post, private_event_post]) }
      it { should_not be_able_to(:read, other_event_post) }
      it { should_not be_able_to(:create, Post) }
      it { should_not be_able_to(:update, global_post) }
      it { should_not be_able_to(:update, public_event_post) }
      it { should_not be_able_to(:update, private_event_post) }
      it { should_not be_able_to(:update, other_event_post) }
      it { should_not be_able_to(:destroy, global_post) }
      it { should_not be_able_to(:destroy, public_event_post) }
      it { should_not be_able_to(:destroy, private_event_post) }
      it { should_not be_able_to(:destroy, other_event_post) }
    end
  end
end