require 'spec_helper'

describe Invitation do
  
  it { should respond_to :event_id }
  it { should respond_to :status }
  it { should respond_to :confirmed_date }
  it { should respond_to :sent_date }
  it { should respond_to :max_party_size }
  it { should respond_to :created_at }
  it { should respond_to :updated_at }
  
  it { should validate_presence_of :event_id }
  
  it { should belong_to(:event).validate }
  it { should have_many(:invitation_users).validate }
  it { should have_many(:users).validate }
  
  describe "Class Methods and Scopes" do
    
    describe "with_user" do
      
    end
    
    describe "with_role" do
      
    end
    
  end
  
end
