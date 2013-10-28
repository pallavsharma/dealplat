Dealplat.Views.Map ||= { }
class Dealplat.Views.Map.GMap extends Dealplat.Views.BaseView
  template: JST["backbone/templates/map/index"]
  id: "map"

  afterRender: ->
    setTimeout =>
      @map = new GMaps
        div: '#map'
        lat: -12.043333
        lng: -77.028333
        minZoom: 4
        click: @setMarker
      @printMarkers()
    , 200


  setMarker: (e) =>
    model = @collection.create({latitude: e.latLng.lb, longitude: e.latLng.mb})
    @printMarker(model)

  printMarkers: -> @collection.each(@printMarker)

  printMarker: (marker) =>
    @map.addMarker
      lat: marker.get('latitude')
      lng: marker.get('longitude')
      title: marker.get('title')
