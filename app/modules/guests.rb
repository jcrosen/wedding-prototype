module Guests
  class Guest < OpenStruct
    # If the user_id value is assigned then we have a guest with an actual user account
    def has_user?
      !(user_id.nil? || user_id == 0)
    end
  end
end