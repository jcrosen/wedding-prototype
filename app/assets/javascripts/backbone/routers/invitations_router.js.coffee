class WeddingPrototype.Routers.InvitationsRouter extends Backbone.Router
  initialize: (options) ->
    @invitations = new WeddingPrototype.Collections.Invitations()
    @columns_per_invitation = options.columns_per_invitation
    @offset = options.offset
    @invitations.fetch()

  routes:
    ".*": "index"

  index: ->
    @iView = new WeddingPrototype.Views.Invitations.IndexView(collection: @invitations, columns_per_invitation: @columns_per_invitation, offset: @offset)
    $("#invitations").html(@iView.render().el)
