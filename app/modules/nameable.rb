module Nameable
  extend ActiveSupport::Concern

  included do
    attr_accessible :first_name, :last_name, :display_name

    def full_name
      if first_name && last_name
        first_name + " " + last_name
      elsif display_name
        display_name
      else
        nil
      end
    end
  end
end