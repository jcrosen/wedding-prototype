class WeddingPrototype.Models.Invitation extends Backbone.Model
  paramRoot: 'invitation'
  url: "/invitations"

  defaults:
    event_id: null
    status: null
    sent_at: null
    confirmed_at: null
    max_party_size: null
    status_hash: null

  initialize: (options) ->
    @guests = new WeddingPrototype.Collections.Guests()
    @guests.invitation_id = @id
    @fetchGuests() if @id

  fetchGuests: ->
    @guests.fetch()

  confirm: (status) ->
    (@sync || Backbone.sync).call @, 'confirm', @,
      url: "#{@url}/#{@id}/confirm"
      data: "status=#{status}"
      type: "PUT"

class WeddingPrototype.Collections.Invitations extends Backbone.Collection
  model: WeddingPrototype.Models.Invitation
  url: '/invitations'

  initialize: (options) ->
    @status_hash = null
