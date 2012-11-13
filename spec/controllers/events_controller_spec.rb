require 'spec_helper'

describe EventsController do
  def create_events(size)
    size.times { Factory.create(:event, is_public: true) }
    Event.all
  end
  
  describe "#index" do
    let(:events) { create_events(5) }
    
    before do
      events
      get :index, format: :html
    end
    
    it { should respond_with(:success) }
    it { should assign_to(:events).with(events) }
  end
  
  describe "#show" do
    let(:event) { Factory.create(:event, is_public: true) }
    
    before do
      event
      get :show, id: event.id, format: :html
    end
    
    it { should respond_with(:success) }
    it { should assign_to(:event).with(event) }
    
  end

end
