# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

window.initializeEventMap = (address, divId) ->

  drawMap = (latLng, marker) ->
    mapOptions =
      center: latLng,
      zoom: 14,
      mapTypeId: google.maps.MapTypeId.HYBRID
      panControl: false
      zoomControl: true
      streetViewControl:false
    
    map = new google.maps.Map(document.getElementById(divId), mapOptions)
    marker = new google.maps.Marker(map: map, position: latLng) 
    
  window.initializeMap = ->
    geocoder = new google.maps.Geocoder()
    geocoder.geocode "address": address, (results, status) -> 
      if (status == google.maps.GeocoderStatus.OK)
        drawMap(results[0].geometry.location)
      else
        alert("Could not determine the location from the passed in address; no map will be drawn.")

  script = document.createElement("script")
  script.type = "text/javascript"
  script.src = "http://maps.googleapis.com/maps/api/js?key=AIzaSyAGOZG3PAabAcK3oIHTNryt4ei_S0-WTkg&sensor=false&callback=initializeMap"
  document.body.appendChild(script)