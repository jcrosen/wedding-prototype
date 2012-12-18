require 'spec_helper'

describe User do
  it { should respond_to :email }
  it { should respond_to :display_name }
  it { should respond_to :created_at }
  it { should respond_to :updated_at }
  
  it { should have_many :invitation_users }
  it { should have_many :invitations }
  it { should have_many :events }
  
  subject { Factory.create(:user) }
  
  describe "#ability" do
    it "returns an instance of the Ability class" do
      expect(subject.ability.class.to_s).to eq("Ability")
    end 
  end
  
  describe "#is_admin?" do
    it "returns false if the user is not an admin" do
      expect(subject.is_admin?).to be_false
    end
    
    it "returns true if the user is an admin" do
      subject.make_admin
      expect(subject.is_admin?).to be_true
    end
  end
  
  describe "#make_admin" do
    it "promotes the user to admin" do
      expect(subject.is_admin?).to be_false
      subject.make_admin
      expect(subject.is_admin?).to be_true
    end
    
    it "does nothing if the user is already an admin" do
      subject.make_admin
      subject.make_admin
      expect(subject.is_admin?).to be_true
    end
  end
  
end
