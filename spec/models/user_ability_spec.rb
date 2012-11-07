require "spec_helper"
require "cancan/matchers"

describe User do
  
  describe "Abilities" do
    subject { ability }
    let(:ability) { Ability.new(user) }
    
    context "when no user is logged in" do
      let(:user) { nil }
      let(:public_event) { Factory.create(:event, is_public: true) }
      let(:private_event) { Factory.create(:event) }
      
      # Cannot access any invitations actions
      it { should_not be_able_to(:manage, :invitations) }
      
      it { should be_able_to(:read, public_event) }
      it { should_not be_able_to(:edit, public_event) }
      it { should_not be_able_to(:update, public_event) }
      it { should_not be_able_to(:destroy, public_event) }
    end
  end
end