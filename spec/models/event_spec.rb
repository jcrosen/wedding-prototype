require 'spec_helper'

describe Event do
  it { should respond_to("title") }
  it { should respond_to("location") }
  it { should respond_to("scheduled_date") }
  
  it { should validate_presence_of("title") }
  
  def create_events(num, public_mod = 3)
    num.times do |i|
      public = public_mod != 0 &&(i % public_mod == 0) ? true : false
      Factory.create(:event, is_public: public)
    end
    Event.all
  end
  
  describe "Scopes/Class Methods" do    
    describe "#public" do
      it "returns all Events with identified as publically visible" do
        create_events(6, 3)
        expect(Event.public.size).to eq(2)
      end
    end
    
    describe "#invited(user)" do
      it "returns all events to which the passed user is invited" do
        user = Factory.create(:user)
        events = create_events(10)
        
        for event in events[0..3] do
          Factory.create(:invitation, user_id: user.id, event_id: event.id)
        end
        
        expect(Event.invited(user)).to match_array(events[0..3])
      end
    end
    
    describe "#get_events_for_user" do
      let(:user) { Factory.create(:user) }
      let(:events) { create_events(10) }
      
      it "returns any public events regardless of the user passed in" do
        events
        expect(Event.get_events_for_user(nil)).to match_array(Event.public)
      end
      
      it "returns any events to which the passed user is invited" do
        for event in events[0..3] do
          Factory.create(:invitation, user_id: user.id, event_id: event.id)
        end
        
        expect(Event.get_events_for_user(user)).to match_array(Event.invited(user) | Event.public)
      end
    end
    
  end
  
  describe "Instance Methods" do
    pending "need to add instance method tests here"
  end
  
end
