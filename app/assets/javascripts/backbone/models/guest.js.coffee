class WeddingPrototype.Models.Guest extends Backbone.Model
  paramRoot: 'guest'

  defaults:
    invitation_id: null
    role: null
    user_id: null
    first_name: null
    last_name: null
    display_name: null

class WeddingPrototype.Collections.Guests extends Backbone.Collection
  initialize: (options) ->
    @invitation = options.invitation
    @fetch

  model: WeddingPrototype.Models.Guest
  url: ->
    "/invitations/#{@invitation.id}/guests"
