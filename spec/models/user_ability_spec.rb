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
    
    subject { ability }
    
    context "when no user is logged in" do
      let(:user) { nil }
      let(:invitation) { Factory.create(:invitation) }
      
      # Cannot access any invitations
      it { should_not be_able_to(:read, Invitation) }
      it { should_not be_able_to(:read, invitation) }
      it { should_not be_able_to(:create, Invitation) }
      it { should_not be_able_to(:update, invitation) }
      it { should_not be_able_to(:destroy, invitation) }
      it { should_not be_able_to(:confirm, invitation) }
      
      # Can access public events
      it { should be_able_to(:read, public_event) }
      it { should_not be_able_to(:create, Event) }
      it { should_not be_able_to(:update, public_event) }
      it { should_not be_able_to(:destroy, public_event) }
    end
    
    context "when an admin is logged in" do
      let(:user) { create_admin }
      
      it { should be_able_to(:manage, Event) }
      it { should be_able_to(:manage, Invitation) }
    end
    
    context "when a non-admin user is logged in" do
      let(:user) { Factory.create(:user) }
      let(:other_event) { Factory.create(:event) }
      let(:invitation) { Factory.create(:invitation, user_id: user.id, event_id: private_event.id) }
      let(:other_invitation) { Factory.create(:invitation, event_id: other_event.id) }
      
      # Need to ensure that the invitations are created before we check the event permissions below in single line it blocks
      before :each do
        invitation
        other_invitation
      end
      
      it { should be_able_to(:read, invitation) }
      it { should be_able_to(:confirm, invitation) }
      it { should_not be_able_to(:update, invitation) }
      it { should_not be_able_to(:destroy, invitation) }
      it { should_not be_able_to(:create, Invitation) }
      
      it { should be_able_to(:read, public_event) }
      it { should be_able_to(:read, private_event) }
      it { should be_able_to(:read, *[public_event, private_event]) }
      it { should_not be_able_to(:read, other_event) }
      it { should_not be_able_to(:create, Event) }
      it { should_not be_able_to(:update, Event) }
      it { should_not be_able_to(:destroy, Event) }
    end
  end
end