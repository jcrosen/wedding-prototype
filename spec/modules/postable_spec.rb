require 'spec_helper'

describe Postable do
  class Event < ActiveRecord::Base
    include Postable
  end
  
  let(:postable_attribute) { "postable_attribute" }
  let(:postable) { Factory.create(:event) }
  let(:post) { Factory.create(:post, postable: postable) }
  
  before do
    post
  end
  
  describe "#posts" do
    subject { postable }
    
    it { should respond_to :posts }
    
    it "returns an array of posts" do
      expect(subject.posts).to be_an_instance_of(Array)
    end
    
    it "returns posts which are associated via the postable association" do
      expect(postable.posts.include?(post)).to be_true
    end
  end
  
end
