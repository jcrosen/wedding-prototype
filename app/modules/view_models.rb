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

  module GuestViewModels
    class GuestViewModel < ViewModel
      ##
      #  Default attributes:
      #   role_hash: Guest role hash
      def self.prepare(args = {})
        args = {} unless args
        args[:role_list] = Guest.role_list unless args[:role_list]
        super(args)
      end

      def as_json(options = {})
        #TODO: Move this out of the base VM and into "sub" VMs (either inheritance or composition)
        if self.guest
          { guest: self.guest.as_json(methods: [:role_list, :errors]), errors: self.errors }
        elsif self.guests
          { guests: self.guests.as_json(methods: :role_list, include: :invitation) }       
        else
          super(options)
        end
      end
    end
  end

  module InvitationViewModels
    class InvitationViewModel < ViewModel
      ##
      #  Default attributes:
      #   status_hash: invitation status hash
      class << self
        def prepare(args = {})
          args = {} unless args
          args[:status_hash] = Invitation.status_hash unless args[:status_hash]
          super(args)
        end
      end

      def as_json(options = {})
        if self.invitation
          { invitation: self.invitation.as_json(methods: [:status_hash, :printable_status], include: [:guests, :event]), errors: self.errors }
        elsif self.invitations
          { invitations: self.invitations.as_json(methods: [:status_hash, :printable_status], include: [:guests, :event]) }
        else
          super(options)
        end
      end
    end
  end
end