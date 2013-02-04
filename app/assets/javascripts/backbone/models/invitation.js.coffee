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
    printable_status: null

  parse: (response) ->
    if response.invitation
      return response.invitation
    else
      return response

  initialize: (options) ->
    @guests = new WeddingPrototype.Collections.Guests()
    @guests.invitation_id = @id
    @fetchGuests() if @id
    @on("change:status", @setPrintableStatus)

  fetchGuests: ->
    @guests.fetch()

  confirm: (status, options) ->
    response = (@sync || Backbone.sync).call @, 'confirm', @,
      url: "#{@url}/#{@id}/confirm"
      data: "status=#{status}"
      type: "PUT"
      success: options.success
      error: options.error
      wait: options.wait

  setPrintableStatus: (invitation) =>
    new_printable_status = invitation.get("status_hash")[invitation.get("status")] #TODO: seems hacky here...
    @set "printable_status", new_printable_status

class WeddingPrototype.Collections.Invitations extends Backbone.Collection
  model: WeddingPrototype.Models.Invitation
  url: '/invitations'

  parse: (response) ->
    console.log "In invitations parse()"
    if response.invitations
      return response.invitations
    else
      return response
    
