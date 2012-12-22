require 'spec_helper'

describe Nameable do

  class NameableClass
    attr_reader :id
    
    class << self
      def attr_accessible(*args)
        args.each do |name|
          attr_accessor name
        end
      end
    end
    
    include Nameable
    
    def initialize(args = {})
      if args
        id = 1
        self.first_name = args[:first_name]
        self.last_name = args[:last_name]
        self.display_name = args[:display_name]
      else
        id = 0
      end
    end
  end

  let(:nameable_class_instance) { NameableClass.new(first_name: "John", last_name: "Doe", display_name: "Johnny") }

  describe "Attributes" do
    subject { nameable_class_instance }

    it { should respond_to :first_name }
    it { should respond_to :last_name }
    it { should respond_to :display_name }

    it "returns the first name passed it during construction" do
      expect(subject.first_name).to eq("John")
    end

    it "returns the last name passed it during construction" do
      expect(subject.last_name).to eq("Doe")
    end

    it "returns the display name passed it during construction" do
      expect(subject.display_name).to eq("Johnny")
    end
  end

  describe "Instance Methods" do
    describe "#full_name" do
      subject { nameable_class_instance }

      it { should respond_to :full_name }

      it "concatenates the first and last names together separated by a space" do
        expect(subject.full_name).to eq("John Doe")
      end
    end
  end

end