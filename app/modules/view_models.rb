module ViewModels
  class ViewModel < OpenStruct
    class << self
      def prepare(args = {})
        self.new(args)
      end
    end
  end

  module EventViewModels
    class EventViewModel < ViewModel
      def prepare(args = {})
        self.new(event: args[:event]) unless args.nil? || args[:event].nil?
      end
    end

    class EventShowModel < EventViewModel
      class << self
        def prepare(args = {})
          _event = args[:event] unless args.nil?

          self.new(event: _event, invitations: _event.invitations, posts: _event.posts) unless _event.nil?
        end
      end
    end

    class EventIndexModel < EventViewModel
      class << self
        def prepare(args = {})
          _events = args[:events] unless args.nil?

          self.new(events: _events)
        end
      end
    end
  end

  module InvitationViewModels
    class InvitationViewModel < ViewModel
      ##
      #  Default attributes:
      #   status_list: invitation status list
      #   printable_status_list: same status list but made printable
      class << self
        def prepare(args = {})
          args = {} unless args
          args.merge!(status_hash: Invitation.status_hash)

          super(args)
        end
      end
    end
  end
end