require 'spec_helper'

include Guests

describe Guests do
  
  describe Guest do

    describe "Instance Methods" do

      describe "#has_user?" do
        let(:guest) { Guest.new() }
        subject { guest }

        it "returns true if user_id is populated" do
          subject.user_id = 1

          expect(subject.has_user?).to be_true
        end

        it "returns false if user_id is nil or 0" do
          subject.user_id = nil
          expect(subject.has_user?).to be_false

          subject.user_id = 0
          expect(subject.has_user?).to be_false
        end
      end
    end

  end

end