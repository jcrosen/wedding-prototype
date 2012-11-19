require 'spec_helper'

describe Post do
  it { should respond_to :title }
  it { should respond_to :raw_body }
  it { should respond_to :rendered_body }
  it { should respond_to :published_at }
  it { should respond_to :user_id }
  it { should respond_to :postable_id }
  it { should respond_to :postable_type }
  it { should respond_to :created_at }
  it { should respond_to :updated_at }
  
  it { should validate_presence_of :title }
  it { should validate_presence_of :raw_body }
  it { should validate_presence_of :user_id }
  
  it { should belong_to :user }
  it { should belong_to :postable }
    
  
  describe "Class Methods" do
    describe "#with_postable" do
      let(:postable) { Factory.create(:event) }
      let(:post) { Factory.create(:post, postable: postable) }
      
      it "returns any posts associated to the passed in postable" do
        expect(Post.with_postable(postable: postable)).to include(post)
        expect(Post.with_postable(postable_id: postable.id, postable_type: postable.class.to_s)).to include(post)
      end
    end
  end
  
  describe "Instance Methods" do
    let(:post) { Factory.create(:post) }
    subject { post }
    
    describe "#is_published?" do
      it { should respond_to :is_published? }
    
      it "returns false if there is not published date" do
        subject.published_at = nil
        
        expect(subject.is_published?).to be_false
      end
      
      it "returns true if there is a published date" do
        subject.published_at = Time.new
        
        expect(subject.is_published?).to be_true
      end
      
    end
    
    describe "#is_global?" do
      it { should respond_to :is_global? }
      
      it "returns true if there is no postable associated" do
        expect(subject.is_global?).to be_true
      end
      
      it "returns false if there is a postable associated" do
        subject.postable = Factory.create(:event)
        expect(subject.is_global?).to be_false
      end
    end
    
  end
  
end