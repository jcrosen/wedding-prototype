WeddingPrototype.Views.Invitations ||= {}

class WeddingPrototype.Views.Invitations.IndexView extends Backbone.View
  template: JST["backbone/templates/invitations/index"]

  initialize: (options) ->
    @invitations = options.collection
    @invitations.bind('reset', @addAll)
    @columns_per_invitation = 6

  addAll: () =>
    invitations_per_row = 2
    row_id = 0
    for invitation, index in @invitations.models
      if index % invitations_per_row == 0
        row_id += 1
        @addRow(@rowIdCss(row_id))
      @addOne(@rowIdCss(row_id), invitation)

  rowIdCss: (id) ->
    return "invitations-row-#{id}"

  addRow: (row_id) =>
    @$("#invitations-index-container").append("<div id='#{row_id}' class='invitations-row row-fluid'></div>")

  addOne: (row_id, invitation) =>
    iview = new WeddingPrototype.Views.Invitations.ShowView(
      model: invitation, 
      collection: @invitations, 
      columns: @columns_per_invitation
    )
    @$("##{row_id}").append(iview.render().el)

  render: =>
    @$el.html(@template())
    @addAll()
    return this
