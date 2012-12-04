class Post < ActiveRecord::Base
  attr_accessible :published_at, :raw_body, :rendered_body, :title, :user_id, :postable
  attr_reader :postable_id, :postable_type
  
  belongs_to :user
  belongs_to :postable, polymorphic: true
  
  validates :title, presence: true
  validates :raw_body, presence: true
  validates :user_id, presence: true
  
  default_scope order("published_at DESC")
  
  before_save :render_body
  
  class << self
    def with_postable(args)
      # This is a little sketch, but I wanted to include a convenience for passing either a postable object or the id and type
      if args[:postable]
        _postable_id = args[:postable].id
        _postable_type = args[:postable].class.to_s
      else
        _postable_id = args[:postable_id]
        _postable_type = args[:postable_type]
      end
        
      where(postable_id: _postable_id, postable_type: _postable_type)
    end
    
    # Posts are global if they aren't assigned to a particular postable model
    def global
      where(postable_id: nil)
    end
    
    # TODO: Can we do this with a single database hit instead of iterating over and hitting for each type?  Would it even matter?
    def with_viewer(user = nil)
      types = Post.uniq.pluck(:postable_type)
      
      # Load globally viewable posts
      posts = Post.global
      
      # Load up each postable type's viewable posts
      types.each do |type|
        posts |= Post.where('postable_type = ? and postable_id in (?)', type, type.classify.constantize.with_viewer(user)) unless type.nil?
      end
      
      posts
    end
  end
  
  def is_published?
    !published_at.nil?
  end
  
  def is_global?
    postable.nil?
  end
  
  private
  def render_body
    @markdown ||= Redcarpet::Markdown.new(Redcarpet::Render::HTML, :autolink => true, :space_after_headers => true)
    
    self.rendered_body = @markdown.render(self.raw_body).html_safe
  end
  
end
