require 'spec_helper'

describe PostsController do
  let(:admin_user) { create_admin }
  let(:posts) { create_posts(5) }
  
  def create_posts(size)
    size.times do |n|
      postable = (n % 2 == 0) ? Factory.create(:event) : nil
      Factory.create(:post, user_id: admin_user.id, postable: postable)
    end
    
    Post.all
  end
  
  context "Guest User" do
    
    describe "#index" do
      before do
        posts
        get :index
      end
      
      it { should respond_with :success }
      it { should assign_to(:posts) }
      
      it "only returns global posts" do
        assigns(:posts).should match_array(Post.with_viewer)
      end
      
    end
    
  end
  
  context "Authenticated User" do
    let(:user) { login_user }
    
    before do
      user
    end
    
    describe "#index" do
      before do
        posts
        get :index
      end
      
      it { should respond_with :success }
      it { should assign_to(:posts) }
      
      it "only returns global posts" do
        assigns(:posts).should match_array(Post.with_viewer(user))
      end
      
    end
    
  end
  
  context "Administrator" do
    let(:admin) { login_admin(admin_user) }
    
    before do
      admin
    end
    
    describe "#index" do
      before do
        posts
        get :index
      end
      
      it { should respond_with :success }
      it { should assign_to(:posts) }
      
      it "returns all posts" do
        assigns(:posts).should match_array(Post.with_viewer(admin))
      end
      
    end
    
  end
  
end
