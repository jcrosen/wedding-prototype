require 'spec_helper'

describe Postable do
  class Event < ActiveRecord::Base
    include Postable
  end
  
  class PostableClass
    attr_reader :id
    
    class << self
      def has_many(field, args)
        #do nothing
        # puts "Calling has_many in a module test class with field: #{field} and args: #{args}"
      end
    end
    
    include Postable
    
    def initialize
      id = 1
    end

  end
  
  let(:postable) { Factory.create(:event) }
  let(:post) { Factory.create(:post, postable: postable) }
  
  describe "#posts" do
    
    before do
      post
    end
    
    subject { postable }
    
    it { should respond_to :posts }
    
    it "returns an array of posts" do
      expect(subject.posts).to be_an_instance_of(Array)
    end
    
    it "returns posts which are associated via the postable association" do
      expect(subject.posts.include?(post)).to be_true
    end
  end
  
  describe "#posts_viewable?" do
    subject { PostableClass.new }
    
    it { should respond_to 'posts_viewable?' }
    
    it "returns true by default" do
      expect(subject.posts_viewable?).to be_true
    end
  end
  
  describe "Class Methods" do    
    subject { PostableClass }
    
    describe "#with_viewer" do
      it "is a proxy for with_user" do
        expect(subject.with_viewer).to match_array(subject.with_user)
      end
    end
    
    describe "#with_user" do
      it "returns an empty array" do
        expect(subject.with_user).to be_empty
      end
    end
  end
  
end
