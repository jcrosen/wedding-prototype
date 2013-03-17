WeddingPrototype.Views.Guests ||= {}

class WeddingPrototype.Views.Guests.AddPreviousView extends Backbone.View
  template: JST["backbone/templates/guests/add_previous"]

  events:
    "click .add" : "addGuest"

  initialize: (options) ->
    @guest = options.guest
    @collection = options.collection
    @collection.bind("add", @setVisibility)
    @collection.bind("remove", @setVisibility)
    @collection.bind("reset", @setVisibility)

  addGuest: () =>
    @collection.create( {display_name: @guest.display_name, user_id: @guest.user_id},
      wait: true,
      success: (guest, response) =>
        @collection.trigger("newGuestSync", guest)
        return true

      error: (guest, xhr) =>
        alert "Unable to add guest: #{guest.get('display_name')}; xhr: #{xhr}"
        console.log "Unable to add guest: #{guest.get('display_name')}; xhr: #{xhr}"
        return false
    )
    return false

  setVisibility: () =>
    hide = false
    @collection.each( (guest) =>
      if @guest.display_name == guest.get('display_name') and @guest.user_id == guest.get('user_id')
        hide = true
    )
    if hide
      @$el.addClass("hidden")
    else
      @$el.removeClass("hidden")

  render: ->
    @$el.html(@template( @guest ))
    @setVisibility()
    @$('.add').css("cursor", "pointer")
    return this
