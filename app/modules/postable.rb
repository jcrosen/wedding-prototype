module Postable
  # allows the use of a convenience "included" block which executes whenever the module is included
  extend ActiveSupport::Concern
  
  included do
    has_many :posts, as: :postable
    
    # Should be overridden by includers
    def posts_viewable?(user = nil)
      true
    end
    
    class << self
      def with_viewer(user = nil)
        with_user(user)
      end
      
      # includer should override
      def with_user(user = nil)
        []
      end
    end
  end
  
end