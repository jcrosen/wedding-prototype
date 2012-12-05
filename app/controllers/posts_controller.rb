class PostsController < ApplicationController
  before_filter :new_post, only: [ :new ]
  before_filter :load_post, only: [ :show, :edit, :update, :destroy ]
  before_filter :load_posts, only: [ :index ]
  before_filter :create_post, only: [ :create ]
  before_filter :update_post, only: [ :update ]
  before_filter :destroy_post, only: [ :destroy ]
  
  respond_to :html, :json
  
  def index
    authorize! :read, *@posts if @posts.any?
    
    respond_with @posts do |format|
      format.html { render }
      format.json { render json: @posts }
    end
  end
  
  def show
    authorize! :read, @post
    
    respond_with @post do |format|
      format.html { render }
      format.json { render json: @post }
    end
  end
  
  private
  def load_post
    @post = Post.find(params[:id])
  end
  
  def load_posts
    @posts = Post.with_viewer(user: current_user)
  end
  
end
