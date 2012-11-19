class Post < ActiveRecord::Base
  attr_accessible :published_at, :raw_body, :rendered_body, :title, :user_id, :postable
  attr_reader :postable_id, :postable_type
  
  belongs_to :user
  belongs_to :postable, polymorphic: true
  
  validates :title, presence: true
  validates :raw_body, presence: true
  validates :user_id, presence: true
  
  class << self
    def with_postable(args)
      # This is a little sketch, but I wanted to include a convenience for passing either with a postable object or the id and type
      if args[:postable]
        _postable_id = args[:postable].id
        _postable_type = args[:postable].class.to_s
      else
        _postable_id = args[:postable_id]
        _postable_type = args[:postable_type]
      end
        
      where(postable_id: _postable_id, postable_type: _postable_type)
    end
  end
  
  def is_published?
    !published_at.nil?
  end
  
  def is_global?
    postable.nil?
  end
end
