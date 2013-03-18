WeddingPrototype.Views.Guests ||= {}

class WeddingPrototype.Views.Guests.NewView extends Backbone.View
  template: JST["backbone/templates/guests/new"]

  events:
    "submit .new-guest-form": "save"

  constructor: (options) ->
    super(options)
    @invitation = options.invitation
    @setupModel()

  save: (e) ->
    e.preventDefault()
    e.stopPropagation()

    @$('.add-guests-button').attr(disabled: "disabled")
    @model.unset("errors")

    @collection.create(@model.toJSON(), 
      wait: true
      success: (guest, xhr, status) =>
        @collection.trigger("newGuestSync", guest)
        @clearInputs()
        @bindFormToModel(@setupModel())

      error: (jqXHR) =>
        errors = $.parseJSON(jqXHR.responseText).errors
        @model.set(errors: errors)
    )
    @$('.add-guests-button').removeAttr("disabled")

  addSubmitAttribute: (attributes) =>
    @$('.add-guests-button')

  clearInputs: =>
    @$(".new-guest-form").find(":input").each ->
      $(this).val("") unless this.type == "submit"

  setupModel: =>
    @model = new @collection.model()
    @model.set('invitation_id', @collection.invitation_id)
    @model.bind("change:errors", @processModelErrors)

  bindFormToModel: (model) =>
    # defined in backbone-rails gem as an override for jQuery's backboneLink; provides change events for each input on the form and binds the form attributes to the model attributes
    @$(".new-guest-form").backboneLink(model)

  render: ->
    @$el.html(@template(@model.toJSON()))
    @bindFormToModel(@model)

    return this

  processModelErrors: () =>
    #console.log "I'm processing the model errors as fired from a change:errors event binding"
    @clearModelErrors()
    @renderModelErrors()

  clearModelErrors: () =>
    $(".new-guest-form").find(".control-group").each ->
      $(this).removeClass("error")
    $(".new-guest-form").find("small.errors").each ->
      $(this).addClass("hidden")
      $(this).html("")

  renderModelErrors: () =>
    _.each(@model.get("errors"), (error, attribute) ->
      $("##{attribute}-errors").html(error)
      $("##{attribute}-errors").removeClass("hidden")
      $("##{attribute}-control-group").addClass("error")
    )