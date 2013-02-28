WeddingPrototype.Views.Invitations ||= {}

class WeddingPrototype.Views.Invitations.ShowEventView extends Backbone.View
  template: JST["backbone/templates/invitations/show_event"]

  initialize: (options) ->
    @model = options.model
    @model.bind('statusConfirmed', @resetStatus)

  makeStatusEditable: =>
    confirm_view = new WeddingPrototype.Views.Invitations.ConfirmView(model: @model)
    @$("#invitation-status-text").html(confirm_view.render().el)

  resetStatus: =>
    @$el.html(@template( @model.toJSON() ))

  render: =>
    @$el.html(@template( @model.toJSON() ))
    @$("#toggle-editable").toggle(@makeStatusEditable, @resetStatus)
    return @
