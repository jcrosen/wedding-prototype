require 'spec_helper'

describe Guest do
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
        iu1 = Factory.create(:guest)
        event = iu1.event
        inv2 = Factory.create(:invitation, event_id: event.id)
        iu2 = Factory.build(:guest, invitation_id: inv2.id, user_id: iu1.user_id)
        
        expect(iu2).to_not be_valid
      end
    end
    
  end
end
