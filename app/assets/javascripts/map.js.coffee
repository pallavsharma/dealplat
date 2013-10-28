# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/


$(document).ready ->
  map = new GMaps
    div: '#map'
    lat: -12.043333
    lng: -77.028333
    minZoom: 4

    click: (e) =>
      $("#myModal").modal("show")
      $("#dermo").on "click",()->
        console.log("dermo click")
        $.ajax(
          url: "/markers"
          type: "POST"
          dataType: "json"
          data: {marker: { latitude: e.latLng.lb, longitude: e.latLng.mb, marker_category_id: $("#marker_marker_category").val(), title: $("#marker_title").val()} }
        ).done (marker) =>
          console.log marker
          $("#myModal").modal("hide")
          map.addMarker
            lat: marker.latitude
            lng: marker.longitude
            marker_category_id: $("#marker_marker_category").val()
            title: $("#marker_title").val()

  $.ajax(
    url: "/markers"
    dataType: "json"
  ).done (markers) =>
    for key, marker of markers
      if marker.latitude && marker.longitude
        map.addMarker
          lat: marker.latitude
          lng: marker.longitude
          title: marker.title

#            title: "Marker#{key}"
#      prompt "enter marker name", (title) =>
#        console.log title
#      map.addMarker
#        lat: e.latLng.lb
#        lng: e.latLng.mb
#        title: title
#      $.ajax(
#        url: "/markers"
#        type: "POST"
#        data: {marker: { latitude: e.latLng.lb, longitude: e.latLng.mb } }
#      ).done =>
#        alert "MARKER INSERTED IN DB"










