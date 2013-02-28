class WeddingPrototype.Routers.EventInvitationsRouter extends Backbone.Router
  initialize: (options) ->
    @invitations = new WeddingPrototype.Collections.Invitations()
    @invitations.reset options.invitations

  routes:
    ".*": "show"

  show: (id) ->
    if id
      invitation = @invitations.get(id)
    else
      invitation = @invitations.first()

    @iView = new WeddingPrototype.Views.Invitations.ShowEventView(model: invitation)
    @gView = new WeddingPrototype.Views.Guests.IndexView(collection: invitation.guests)
    $("#invitations").html(@iView.render().el)
    $("#invitations").append(@gView.render().el)

