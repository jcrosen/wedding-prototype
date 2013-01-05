require 'spec_helper'

describe EventsController do
  
  def create_events(size)
    size.times { |n| Factory.create(:event, is_public: n % 2 == 0 ? true : false) }
    Event.all
  end
  
  let(:events) { create_events(5) }
  
  context "Guest User" do    
    describe "#index" do
      before do
        events
        get :index, format: :html
      end
      
      it { should respond_with(:success) }
      it { should assign_to(:events) }
    end
    
    describe "#show" do
      context "Public Event" do
        let(:event) { Factory.create(:event, is_public: true) }
      
        before do
          event
          get :show, id: event.id, format: :html
        end
        
        it { should respond_with(:success) }
        it { should assign_to(:event).with(event) }
      end
      
      context "Private Event" do
        let(:event) { Factory.create(:event) }
      
        before do
          event
          get :show, id: event.id, format: :html
        end
        
        it { should redirect_to root_path }
        it { should set_the_flash[:alert] }
      end
    end
    
  end
  
  context "Admin" do
    let(:admin) { login_admin }
    
    before do
      admin
    end
    
    describe "#index" do
      before do
        events
        get :index, format: :html
      end
      
      it { should respond_with(:success) }
      it { should assign_to(:events) }
    end
    
    describe "#show" do
      let(:event) { Factory.create(:event) }
      
      before do
        event
        get :show, id: event.id, format: :html
      end
      
      it { should respond_with(:success) }
      it { should assign_to(:event).with(event) }
      it { should assign_to(:invitations) }
    end
    
  end
  
  context "Authenticated User" do
    let(:user) { login_user }
    
    before do
      user
    end
    
    describe "#index" do
      before do
        events
        get :index, format: :html
      end
      
      it { should respond_with(:success) }
      it { should assign_to(:events) }
    end
    
    describe "#show" do
      before do
        event
        get :show, id: event.id, format: :html
      end
        
      context "Private non-invited event" do
        let(:event) { Factory.create(:event) }
        
        it { should redirect_to root_path }
        it { should set_the_flash[:alert] }
      end
      
      context "Private invited event" do
        let(:event) {
          e = Factory.create(:event)
          i = Factory.create(:invitation, event_id: e.id)
          Factory.create(:guest, invitation_id: i.id, user_id: user.id)
          e 
        }
        
        it { should respond_with(:success) }
        it { should assign_to(:event).with(event) }
        it { should assign_to(:invitations) }
      end
    end
    
  end

end
