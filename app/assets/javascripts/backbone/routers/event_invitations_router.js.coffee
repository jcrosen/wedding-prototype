class WeddingPrototype.Routers.EventInvitationsRouter extends Backbone.Router
  initialize: (options) ->
    @invitations = new WeddingPrototype.Collections.Invitations()
    @invitations.reset options.invitations
    @base_url = options.base_url

  routes:
    "/confirm": "confirm"
    "/:id": "show"
    ".*": "show"

  show: (id) ->
    if id
      invitation = @invitations.get(id)
    else
      invitation = @invitations.first()

    @iView = new WeddingPrototype.Views.Invitations.ShowView(model: invitation)
    @gView = new WeddingPrototype.Views.Guests.IndexView(collection: invitation.guests)
    $("#invitations").html(@iView.render().el)
    $("#guest-list").html(@gView.render().el)

  confirm: (id) ->
    invitation = @invitations.get(id)

    @view = new WeddingPrototype.Views.Invitations.ConfirmView(model: invitation)
    $("#invitations").html(@view.render().el)

