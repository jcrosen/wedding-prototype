require 'spec_helper'

describe PagesController do
  
  def create_events(num, public_mod = 3)
    events = []
    num.times do |i|
      public = public_mod != 0 &&(i % public_mod == 0) ? true : false
      events << Factory.create(:event, is_public: public)
    end
    events
  end
  
  def create_posts(num)
    posts = []
    num.times { posts << Factory.create(:post) }
    posts
  end
  
  #TODO: Create more contexts for the main page based on which user is viewing
  describe "#index" do
    let(:events) { create_events(5, 1) }
    let(:posts) { create_posts(5) }
    
    before do
      events
      posts
      get :index, format: :html
    end
    
    it { should respond_with(:success) }
    it { should assign_to(:events) }
    it { should assign_to(:posts) }
    
    it "should assign only the first 3 events" do
      assigns(:events).should match_array(Event.limit(3))
    end
    
    it "should assign only the first 3 posts" do
      assigns(:posts).should match_array(Post.with_viewer.recent)
    end
    
  end
  
end
