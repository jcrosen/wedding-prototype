require 'spec_helper'

describe Event do
  describe "Attributes" do
    pending "Need to describe the attributes here"
  end
  
  describe "Scopes/Class Methods" do
      
    def create_events(num, public_mod = 3)
      events = []
      num.times do |i|
        public = public_mod != 0 &&(i % public_mod == 0) ? true : false
        events << Factory.create(:event, is_public: public)
      end
      events
    end
    
    describe "#public" do
      it "returns all Events with identified as publically visible" do
        create_events(6, 3)
        expect(Event.public.size).to eq(2)
      end
    end
    
    describe "#invited(user)" do
      it "should return all events to which the passed user is invited" do
        user = Factory.create(:user)
        events = create_events(10)
        for event in events[0..3] do
          Factory.create(:invitation, user_id: user.id, event_id: event.id)
        end
        
        expect(Event.invited(user).size).to eq(4)
      end
    end
    
  end
  
end
