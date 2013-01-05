class WeddingPrototype.Routers.EventInvitationsRouter extends Backbone.Router
  initialize: (options) ->
    @invitations = new WeddingPrototype.Collections.Invitations()

  routes:
    "/confirm": "confirm"
    ".*": "show"

  show: (id) ->
    if id
      invitation = @invitations.get(id)
    else
      invitation = @invitations.first()

    @i_view = new WeddingPrototype.Views.Invitations.ShowView(model: invitation)
    $("#invitations").html(@view.render().el)

  confirm: (id) ->
    invitation = @invitations.first()

    @view = new WeddingPrototype.Views.Invitations.ConfirmView(model: invitation)
    $("#invitations").html(@view.render().el)

