require 'spec_helper'

describe Postable do
  
  class PostableClass
    attr_reader :id
    
    class << self
      def has_many(field, args)
        instance_eval "def posts; return [Post.new]; end;"
      end
    end
    
    include Postable
    
    def initialize
      id = 1
    end

  end
  
  #NOTE: This code uses direct references to external objects/models because mocking up all of the activerecord stuff isn't worth it given we have a limited number of Postables anyway
  #TODO: If moving this module out of this specific application then this testing should be refactored to not require a defined AR model with an existing migrated db/table
  describe "#posts" do
    let(:postable) { Factory.create(:event) }
    let(:post) { Factory.create(:post, postable: postable) }

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
        expect(subject.with_viewer).to be_nil
      end
    end
    
    describe "#with_user" do
      it "returns an empty array" do
        expect(subject.with_user).to be_nil
      end
    end
  end
  
end
