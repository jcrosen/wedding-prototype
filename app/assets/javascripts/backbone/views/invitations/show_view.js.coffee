WeddingPrototype.Views.Invitations ||= {}

class WeddingPrototype.Views.Invitations.ShowView extends Backbone.View
  template: JST["backbone/templates/invitations/show"]

  initialize: (options) ->
    @invitation = options.model
    @collection = options.collection
    @columns = options.columns or 12

  addConfirmation: =>
    cview = new WeddingPrototype.Views.Invitations.ConfirmationView(invitation: @invitation)
    @$(".invitation-status-confirmation").html(cview.render().el)

  render: () =>
    console.log @invitation
    @$el.html(@template(invitation: @invitation, event: @invitation.get('event'), columns: @columns))
    @$el.addClass("span#{@columns}")
    @addConfirmation()
    return this