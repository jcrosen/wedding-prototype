class Post < ActiveRecord::Base
  attr_accessible :published_at, :raw_body, :rendered_body, :title, :user_id, :postable
  attr_reader :postable_id, :postable_type
  
  belongs_to :user
  belongs_to :postable, polymorphic: true
  
  validates :title, presence: true
  validates :raw_body, presence: true
  validates :user_id, presence: true
  
  default_scope order("published_at DESC")
  scope :published, lambda { where("published_at <= ?", Time.zone.now) }
  scope :recent, lambda { published.limit(5) }
  scope :global, lambda { where(postable_id: nil) }
  
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
    
    # TODO: Can this somehow be streamlined so the method is dynamically generated once at application start time instead of having to do a runtime class_eval call?
    # WARNING: Metaprogramming contained within this method; it dynamically creates the where condition to include an option for each postable type
    def with_viewer(user = nil)
      
      # Find distinct postable types currently stored in the database
      types = Post.uniq.pluck(:postable_type)
      
      # Load globally viewable posts
      criteria_text = "postable_id is NULL"
      value_text = ""
      
      # Load up each postable type's viewable posts
      types.each do |type|
        criteria_text += " or (postable_type = ? and postable_id in (?))" unless type.nil?
        value_text += "#{value_text.empty? ? '' : ','} '#{type}', #{type.classify.constantize}.with_viewer(user)" unless type.nil?
      end
      
      # combine the criteria and value strings together here; need to also define the user variable to be used on each call to with_viewer
      eval_text = "user = #{user.nil? ? 'nil' : "User.find(#{user.id})" }; where('#{criteria_text}', #{value_text})"
      
      # This guy hits the database and returns records based on the structured query above
      class_eval eval_text
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
