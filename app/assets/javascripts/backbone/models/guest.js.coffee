class WeddingPrototype.Models.Guest extends Backbone.Model
  paramRoot: 'guest'

  defaults:
    invitationId: null
    role: null
    userId: null
    firstName: null
    lastName: null
    displayName: null
    email: null

class WeddingPrototype.Collections.GuestsCollection extends Backbone.Collection
  initialize: (options) ->
    @invitation = options.invitation
    @fetch

  model: WeddingPrototype.Models.Guest
  url: ->
    "invitations/#{@invitation.url()}/guests"
