WeddingPrototype.Views.Guests ||= {}

class WeddingPrototype.Views.Guests.IndexView extends Backbone.View
  template: JST["backbone/templates/guests/index"]

  initialize: (options) ->
    @guests = options.collection
    @guests.bind('reset', @addAll)
    @guests.bind('newGuestSync', @addOne)

  addAll: () =>
    @guests.each(@addOne)

  addOne: (guest) =>
    view = new WeddingPrototype.Views.Guests.ShowView(model: guest)
    @$("#guests").append(view.render().el)

  addNewView: () =>
    view = new WeddingPrototype.Views.Guests.NewView(invitation: @guests.invitation, collection: @guests)
    @$("#new-guest").replaceWith(view.render().el)

  render: =>
    @$el.html(@template(guests: @guests.toJSON()))
    @addAll()
    @addNewView()

    return this