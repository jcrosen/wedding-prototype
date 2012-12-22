module Nameable
  extend ActiveSupport::Concern

  included do
    attr_accessible :first_name, :last_name, :display_name

    def full_name
      first_name + " " + last_name
    end
  end
end