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
    event: null
    guests: null
    other_guests_list: null

  parse: (response) ->
    if response.invitation
      return response.invitation
    else
      return response

  initialize: (options) ->
    @options = options

  confirm: (status, options) ->
    response = (@sync || Backbone.sync).call @, 'confirm', @,
      url: "#{@url}/#{@id}/confirm"
      data: "status=#{status}"
      type: "PUT"
      success: options.success
      error: options.error
      wait: options.wait

  updateOtherGuests: (collection) =>
    console.log "in updateOtherGuests"
    console.log collection
    other_guests = []
    for guest in collection.models
      display_name = guest.get('display_name')
      user_id = guest.get('user_id')
      id = display_name + (if not user_id then "" else "#{user_id}")
      og = 
        id: id
        display_name: display_name
        user_id: user_id
      other_guests.push og
    
    @.get('other_guests_list').push other_guests...
    @makeOtherGuestsUnique()

  makeOtherGuestsUnique: =>
    console.log "making others unique"
    output = {}
    output[og.id] = og for og in @.get('other_guests_list')
    console.log output
    others = (value for key, value of output)
    console.log others
    @.set('other_guests_list', others)
    console.log @.get('other_guests_list')

class WeddingPrototype.Collections.Invitations extends Backbone.Collection
  model: WeddingPrototype.Models.Invitation
  url: '/invitations'

  parse: (response) ->
    if response.invitations
      return response.invitations
    else
      return response
    
