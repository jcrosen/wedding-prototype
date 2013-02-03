WeddingPrototype.Views.Guests ||= {}

class WeddingPrototype.Views.Guests.ShowView extends Backbone.View
  template: JST["backbone/templates/guests/show"]

  events:
    "click .destroy" : "destroy"

  destroy: () ->
    this.remove() if @model.destroy(wait: true,
        success: (guest, response) ->
          #console.log "Deleting guest: #{guest}"
          return true

        error: (guest, xhr) ->
          alert "Unable to delete guest: #{guest}; xhr: #{xhr}"
          #console.log "Unable to delete guest: #{guest}; xhr: #{xhr}"
          return false
      )

    return false

  render: ->
    @$el.html(@template( @model.toJSON() ))
    return this
