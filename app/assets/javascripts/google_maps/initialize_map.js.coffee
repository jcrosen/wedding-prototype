window.initializeMap = (address, divId) ->
  buildContextMenu = (map) ->
    contextMenuOptions = {}
    contextMenuOptions.classNames = 
      menu:'context-menu', 
      menuSeparator:'context-menu-separator'
    
    menuItems = []
    menuItems.push { className:"context-menu-item", eventName: "zoom_in_click", label: "Zoom In" }
    menuItems.push { className:"context-menu-item", eventName: "zoom_out_click", label: "Zoom Out" }
    menuItems.push { className:"context-menu-separator" }
    menuItems.push { className:"context-menu-item", eventName: "center_map_click", label: "Center map here" }
    contextMenuOptions.menuItems = menuItems
    
    contextMenu = new ContextMenu(map, contextMenuOptions)
    google.maps.event.addListener map, 'rightclick', (mouseEvent) ->
      contextMenu.show(mouseEvent.latLng)
      
    google.maps.event.addListener contextMenu, 'menu_item_selected', (latLng, eventName) ->
      switch eventName
        when "zoom_in_click" then map.setZoom(map.getZoom() + 1)
        when "zoom_out_click" then map.setZoom(map.getZoom() - 1)
        when "center_map_click" then map.panTo(latLng)
        
      
  buildInfoWindow = (map, marker) ->
    contentString = '<div class="infoWindow"><p>' + address + '</p><a href="http://maps.google.com/maps?q=' + address + '" target="_blank">Large map</a></div>'
    infoWindow = new google.maps.InfoWindow content: contentString
    google.maps.event.addListener marker, 'click', ->
      infoWindow.open(map, marker)
  
  drawMap = (latLng, marker) ->
    mapOptions =
      center: latLng,
      zoom: 16,
      mapTypeId: google.maps.MapTypeId.HYBRID
      panControl: false
      zoomControl: true
      streetViewControl:true
    
    map = new google.maps.Map(document.getElementById(divId), mapOptions)
    marker = new google.maps.Marker(map: map, position: latLng, title: address)
    buildContextMenu(map)
    buildInfoWindow(map, marker)
    
  geocoder = new google.maps.Geocoder()
  geocoder.geocode "address": address, (results, status) -> 
    if (status == google.maps.GeocoderStatus.OK)
      drawMap(results[0].geometry.location)
    else
      alert("Could not determine the location from the passed in address: #{address}; no map will be drawn in div #{divId}.")