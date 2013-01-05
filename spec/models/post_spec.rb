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
  
  def create_posts(num = 3, args = {})
    posts = []
    num.times { posts << Factory.create(:post, args) }
    posts
  end
  
  describe "Class Methods and Scopes" do
    let(:postable) { Factory.create(:event) }
    let(:post) { Factory.create(:post) }
    let(:postable_post) { Factory.create(:post, postable: postable) }
    let(:published_post) { Factory.create(:post, published_at: Time.now) }
    
    before do
      post
      postable_post
    end
    
    describe "#with_postable" do
      it "returns any posts associated to the passed in postable" do
        expect(Post.with_postable(postable: postable)).to include(postable_post)
        expect(Post.with_postable(postable_id: postable.id, postable_type: postable.class.to_s)).to include(postable_post)
        expect(Post.with_postable(postable: postable)).to_not include(post)
      end
    end
    
    describe "#global" do
      it "returns any posts not associated with a postable" do
        expect(Post.global).to include(post)
        expect(Post.global).to_not include(postable_post)
      end
    end
    
    describe "#published" do
      it "returns only posts that have been published" do
        create_posts(3)
        published_post
        expect(Post.published).to include(published_post)
        expect(Post.published.size).to eq(1)
      end
    end
    
    describe "#recent" do
      it "returns only the previous five published posts" do
        create_posts(8, published_at: Time.now)
        expect(Post.recent.size).to eq(5)
      end
    end
    
    describe "with_viewer" do
      #TODO: Consider refactoring, it knows too much about other models at this point
      let(:viewable) { Factory.create(:invitation, event_id: postable.id) }
      let(:viewable_user) { Factory.create(:guest, invitation_id: viewable.id) }
      let(:non_viewable_postable) { Factory.create(:event) }
      let(:non_viewable_post) { Factory.create(:post, postable: non_viewable_postable) }
      
      context "No User" do
        it "returns only global records" do
          expect(Post.with_viewer).to include(post)
          expect(Post.with_viewer).to_not include(postable_post)
        end
      end
      
      context "Invited User" do
        before do
          post
          viewable
          viewable_user
          non_viewable_post
        end
        
        subject{ Post.with_viewer(viewable_user.user) }
        
        it "returns both global records any any to which the user is invited in addition to global posts" do
          expect(subject).to include(post)
          expect(subject).to include(postable_post)
          expect(subject).to_not include(non_viewable_post)
        end
      end
      
      context "Administrator" do
        def create_admin
          u = Factory.create(:user)
          u.make_admin
          u.save
          u
        end
        
        let(:admin) { create_admin }
        
        before do
          viewable
          non_viewable_post
        end
        
        subject{ Post.with_viewer(admin) }
        
        it "returns all posts" do
          expect(subject).to include(post)
          expect(subject).to include(postable_post)
          expect(subject).to include(non_viewable_post)
        end
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