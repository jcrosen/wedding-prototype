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
  it { should have_many(:guests).validate }
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
          Factory.create(:guest, user_id: index < _num ? _user.id : _other_user.id, invitation_id: inv.id)
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
          Factory.create(:guest, role: index < _num ? _role : 'viewer', invitation_id: inv.id)
        end
        
        expect(Invitation.with_role(_role).size).to eq(_num)
      end
    end
    
  end
  
  describe "Instance Methods" do
    
    describe "#confirm" do
      let(:invitation) { Factory.create(:invitation) }
      let(:guest) { Factory.create(:guest, invitation_id: invitation.id) }
      
      before do
        guest
      end
      
      subject { invitation }
      
      it "sets the status and confirmed_at dates" do
        _status = "attending"
        
        expect(subject.confirm(status: _status)).to be_true
        expect(subject.status_is_attending?).to be_true
        expect(subject.confirmed_at).to_not be_nil
      end
      
      it "allows a symbol passed as the status" do
        _status = :attending
        
        expect(subject.confirm(status: _status)).to be_true
        expect(subject.status_is_attending?).to be_true
        expect(subject.confirmed_at).to_not be_nil
      end
      
      it "returns an error when attempting to set a status not in the status_list" do
        _status = "wrong_status"
        
        expect(subject.confirm(status: _status)).to be_false #TODO: Make this instead check for an error in the model's errors list
      end
      
    end
    
    describe "#reset_confirmation" do
      let(:invitation) { i = Factory.create(:invitation); i.confirm(status: :attending); i }
      subject { invitation }
      
      it "resets the status and confirmed date" do
        subject.reset_confirmation
        
        expect(subject.status_is_unconfirmed?).to be_true
        expect(subject.confirmed_at).to be_nil
      end
      
    end
    
    describe "#confirmed?" do
      let(:i_confirmed) { i = Factory.create(:invitation); i.confirm(status: :attending); i }
      let(:i_unconfirmed) { Factory.create(:invitation, status: :unconfirmed) }
      
      it "returns true when an invitation is confirmed" do
        expect(i_confirmed.confirmed?).to be_true
      end
      
      it "returns false when an invitation does not have complete confirmation" do
        expect(i_unconfirmed.confirmed?).to be_false
      end
      
    end

    describe "#other_guests_list" do
      def create_guests(num, atts={})
        guests = []
        num.times { guests << Factory.create(:guest, atts) }
        return guests
      end

      def build_guests_list(guests)
        guests_list = []
        guests.each do |g|
          id = g.display_name + (g.user_id ? "-#{g.user_id.to_s}" : "")
          guest_hash = { id: id, display_name: g.display_name, user_id: g.user_id }
          guests_list << guest_hash
        end
        return guests_list
      end


      let(:user) { Factory.create(:user) }
      let(:invitation) { Factory.create(:invitation) }
      let(:guest) { Factory.create(:guest, user_id: user.id, invitation_id: invitation.id, role: 'owner') }
      
      let(:other_invitation) { Factory.create(:invitation) }
      let(:guest_on_other_invitation) {
        Factory.create(:guest, user_id: guest.user_id, invitation_id: other_invitation.id, role: 'owner')
      }
      let(:other_guests) { create_guests(3, invitation_id: other_invitation.id) }

      before do
        other_guests
        guest_on_other_invitation
      end

      it "returns a list of guests from other invitations owned by the same user passed in" do
        match_other_guests = build_guests_list(other_invitation.guests)
        expect(invitation.other_guests_list(user)).to match_array(match_other_guests)
      end

      it "returns a list of guests from other invitations owned by the set current_user value" do
        match_other_guests = build_guests_list(other_invitation.guests)
        invitation.current_user = user
        expect(invitation.other_guests_list).to match_array(match_other_guests)
      end
    end
    
  end
  
end
