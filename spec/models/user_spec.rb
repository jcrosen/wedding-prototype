require 'spec_helper'

describe User do
  
  describe "#is_admin?" do
    subject { u = Factory.create(:user) }
    
    it "returns false if the user is not an admin" do
      expect(subject.is_admin?).to be_false
    end
    
    it "returns true if the user is an admin" do
      subject.make_admin
      expect(subject.is_admin?).to be_true
    end
  end
  
  describe "#make_admin" do
    subject { Factory.create(:user) }

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
