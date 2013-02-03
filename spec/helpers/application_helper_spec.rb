require 'spec_helper'

describe ApplicationHelper do
  describe "#active_model_errors_to_json" do
    class AMErrors
      extend ActiveModel::Naming
      extend ActiveModel::Translation

      def initialize
        @errors = ActiveModel::Errors.new(self)
      end

      attr_accessor :error_attribute
      attr_reader :errors

      def validate!
        errors.add(:error_attribute, "can not be nil") if error_attribute.nil?
        errors.add(:error_attribute, "can not be null either") if error_attribute.nil?
      end

      # The following method is needed to be minimally implemented for AM Errors
      def read_attribute_for_validation(attr)
        send(attr)
      end
    end

    before do
      am = AMErrors.new
      am.validate!
      @am_errors = am.errors
    end

    subject { active_model_errors_to_json(@am_errors) }

    it { should be_an_instance_of Hash }
    it { should include :full_messages }
    it { should include :error_attribute }

    it "returns a string of error messages for each attribute" do
      expect(subject[:error_attribute]).to be_an_instance_of String
    end
    # This is a rather brittle test, I could also just let it check that each attribute is represented by a string and leave it at that...
    it "returns the error_attribute with a joined list of error messages separated by a comma and space" do
      expect(subject[:error_attribute]).to eq @am_errors[:error_attribute].join(", ")
    end
  end
end
