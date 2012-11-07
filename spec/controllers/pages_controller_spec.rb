require 'spec_helper'

describe PagesController do
  
  def create_events(num, public_mod = 3)
    events = []
    num.times do |i|
      public = public_mod != 0 &&(i % public_mod == 0) ? true : false
      events << Factory.create(:event, is_public: public)
    end
    events
  end
  
  describe "#index" do
    let(:events) { create_events(5, 1) }
    
    before do
      events
      get :index, format: :html
    end
    
    it { should respond_with(:success) }
    it { should assign_to(:events).with(events) }
  end
  
end
