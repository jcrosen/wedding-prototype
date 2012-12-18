require 'spec_helper'

describe Invitation do
  
  it { should respond_to :event_id }
  it { should respond_to :status }
  it { should respond_to :confirmed_at }
  it { should respond_to :sent_at }
  it { should respond_to :max_party_size }
  it { should respond_to :created_at }
  it { should respond_to :updated_at }
  
  it { should validate_presence_of :event_id }
  
  it { should belong_to(:event).validate }
  it { should have_many(:invitation_users).validate }
  it { should have_many(:users).validate }
  
  def create_invitations(num)
    num.times do |i|
      Factory.create(:invitation)
    end
    Invitation.all
  end
  
  describe "Class Methods and Scopes" do
    
    describe "#with_user" do
      it "returns records with the specified user" do
        _invitations = create_invitations(10)
        _user = Factory.create(:user)
        _other_user = Factory.create(:user)
        _num = 4
        
        _invitations.each_with_index do |inv, index|
          Factory.create(:invitation_user, user_id: index < _num ? _user.id : _other_user.id, invitation_id: inv.id)
        end
        
        expect(Invitation.with_user(_user).size).to eq(_num)
      end
    end
    
    describe "#with_role" do
      it "returns records with the specified user" do
        _invitations = create_invitations(10)
        _role = "owner"
        _num = 4
        
        _invitations.each_with_index do |inv, index|
          Factory.create(:invitation_user, role: index < _num ? _role : 'reader', invitation_id: inv.id)
        end
        
        expect(Invitation.with_role(_role).size).to eq(_num)
      end
    end
    
  end
  
  describe "Instance Methods" do
    
    describe "#confirm" do
      let(:invitation) { Factory.create(:invitation) }
      let(:invitation_user) { Factory.create(:invitation_user, invitation_id: invitation.id) }
      
      before do
        invitation_user
      end
      
      subject { invitation }
      
      it "sets the status and confirmed_at dates" do
        _status = "attending"
        subject.confirm(status: _status)
        
        expect(subject.status).to eq(_status)
        expect(subject.confirmed_at).to_not be_nil
      end
      
      it "returns an error when attempting to set a status not in the status_list" do
        _status = "wrong_status"
        
        expect(subject.confirm(status: _status)).to be_false #TODO: Make this instead check for an error in the model's errors list
      end
      
    end
    
  end
  
end
