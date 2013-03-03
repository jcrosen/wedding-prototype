class WeddingPrototype.Routers.InvitationsRouter extends Backbone.Router
  initialize: (options) ->
    @invitations = new WeddingPrototype.Collections.Invitations()
    @invitations.fetch()

  routes:
    ".*": "index"

  index: ->
    @iView = new WeddingPrototype.Views.Invitations.IndexView(collection: @invitations)
    $("#invitations").html(@iView.render().el)
