class WeddingPrototype.Routers.EventInvitationsRouter extends Backbone.Router
  initialize: (options) ->
    @invitation = new WeddingPrototype.Models.Invitation(options.invitation)
    @invitation.fetch(async: false)

  routes:
    ".*": "show"

  show: () ->
    @iView = new WeddingPrototype.Views.Invitations.ShowView( model: @invitation, only_confirmation: true )
    $("#invitation-confirmation").html(@iView.render().el)

