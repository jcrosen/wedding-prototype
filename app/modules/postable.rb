module Postable
  # allows the use of a convenience "included" block which executes whenever the module is included
  extend ActiveSupport::Concern
  
  included do
    has_many :posts, as: :postable
    
    # Includer should override this class method before including the module
    if !defined? with_user
      def self.with_user(user = nil)
        nil
      end
    end
    
    # Should be overridden by includers
    def posts_viewable?(user = nil)
      true
    end
    
    class << self
      def with_viewer(user = nil)
        with_user(user)
      end
    end
  end
  
end