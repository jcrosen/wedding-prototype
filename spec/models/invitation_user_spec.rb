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

    describe "#guest_name" do
      let(:guest) { Factory.create(:invitation_user, user_id: nil, first_name: "John", last_name: "Doe") }
      let(:guest_user) { Factory.create(:user, first_name: "Johnz", last_name: "Doez") }

      it "returns the full name saved with the invitation user when a user is not present" do
        expect(guest.guest_name).to eq("John Doe")
      end

      it "returns the full name associated with the user when the association is present" do
        guest.user = guest_user
        guest.save

        expect(guest.guest_name).to eq("Johnz Doez")
      end
    end
    
  end
end
