require 'spec_helper'

describe InvitationUser do
  it { should respond_to :role }
  it { should respond_to :user_id }
  it { should respond_to :invitation_id }
  
  it { should_not validate_presence_of :user_id }
  it { should validate_presence_of :invitation_id }
  it { should validate_presence_of :role }
  
  it { should belong_to :user }
  it { should belong_to :invitation }
  it { should have_one(:event).through(:invitation) }
  
  describe "Class Methods and Scopes" do
    
    describe "with_user" do
      
    end
    
    describe "with_role" do
      
    end
    
  end
  
  describe "Instance Methods" do
    
    describe "#validate_uniqueness_of_event" do
      it "adds an error if a user is already invited to the same event" do
        iu1 = Factory.create(:invitation_user)
        event = iu1.event
        inv2 = Factory.create(:invitation, event_id: event.id)
        iu2 = Factory.build(:invitation_user, invitation_id: inv2.id, user_id: iu1.user_id)
        
        expect(iu2).to_not be_valid
      end
    end

    describe "#guest" do
      let(:user) { Factory.create(:user, first_name: "Johnz", last_name: "Doez") }
      let(:invitation_user) { Factory.create(:invitation_user, user_id: user.id, first_name: "John", last_name: "Doe") }

      it "returns a Guest object with the name, display_name, first_name, last_name, and user_id attributes" do
        guest = invitation_user.guest

        expect(guest).to be_an_instance_of(Guests::Guest)
        expect(guest.full_name).to be
        expect(guest.first_name).to be
        expect(guest.last_name).to be
        expect(guest.display_name).to be
        expect(guest.user_id).to be
      end

      it "returns a Guest with data matching that of the invitation user when not associated to a user" do
        invitation_user.user = nil
        invitation_user.save
        guest = invitation_user.guest

        expect(guest.full_name).to eq(invitation_user.full_name)
        expect(guest.first_name).to eq(invitation_user.first_name)
        expect(guest.last_name).to eq(invitation_user.last_name)
        expect(guest.display_name).to eq(invitation_user.display_name)
        expect(guest.user_id).to be_nil
      end

      it "returns the full name associated with the user when the association is present" do
        guest = invitation_user.guest

        expect(guest.full_name).to eq(user.full_name)
        expect(guest.first_name).to eq(user.first_name)
        expect(guest.last_name).to eq(user.last_name)
        expect(guest.display_name).to eq(user.display_name)
        expect(guest.user_id).to eq(user.id)
      end
    end
    
  end
end
