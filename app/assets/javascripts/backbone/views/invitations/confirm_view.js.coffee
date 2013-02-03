WeddingPrototype.Views.Invitations ||= {}

class WeddingPrototype.Views.Invitations.ConfirmView extends Backbone.View
  template: JST["backbone/templates/invitations/confirm"]

  events:
    "change #confirm-select": "confirm"

  confirm: ->
    @model.confirm(@$("#confirm-select").attr("value"),
      wait: true
      success: (guest, xhr, status) =>
        @model.trigger("statusConfirmed")
      error: (jqXHR) =>
        console.log "Error: #{jqXHR}"
    )

  render: ->
    console.log @model.toJSON()
    @$el.html(@template( @model.toJSON() ))
    return this
