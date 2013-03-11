WeddingPrototype.Views.Guests ||= {}

class WeddingPrototype.Views.Guests.ShowView extends Backbone.View
  template: JST["backbone/templates/guests/show"]

  events:
    "click .destroy" : "destroy"

  initialize: (options) ->
    @guest = options.guest
    @invitation = options.invitation
    @guest.set('can_edit', @invitation.get('current_user').id != @guest.get('user_id'))

  destroy: () =>
    @guest.destroy(
      wait: true,
      success: (guest, response) =>
        @remove()
        return true

      error: (guest, xhr) =>
        alert "Unable to delete guest: #{guest.get('display_name')}; xhr: #{xhr}"
        console.log "Unable to delete guest: #{guest.get('display_name')}; xhr: #{xhr}"
        return false
    )

    return false

  render: ->
    @$el.html(@template( @guest.toJSON() ))
    return this
