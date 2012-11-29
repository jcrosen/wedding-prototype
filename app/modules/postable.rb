module Postable
  # allows the use of a convenience "included" block which executes whenever the module is included
  extend ActiveSupport::Concern
  
  included do
    has_many :posts, as: :postable
  end
  
end