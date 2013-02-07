WeddingPrototype.Views.Invitations ||= {}

class WeddingPrototype.Views.Invitations.ConfirmView extends Backbone.View
  template: JST["backbone/templates/invitations/confirm"]

  events:
    "click #confirm-select": "confirm"

  confirm: ->
    new_status = @$("#confirm-select-box").attr("value")
    @model.confirm(new_status,
      wait: true
      success: (guest, xhr, status) =>
        console.log "Confirmation is successful!"
        @model.set("status": new_status)
        @model.trigger("statusConfirmed")
      error: (jqXHR) =>
        console.log "Error: #{jqXHR}"
    )

  render: ->
    @$el.html(@template( @model.toJSON() ))
    return this
