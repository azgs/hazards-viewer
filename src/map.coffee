layer = new L.TileLayer "http://a.tiles.mapbox.com/v3/rclark.map-x9c4guq4/{z}/{x}/{y}.png"
center = new L.LatLng 33.610044573695625, -111.50024414062501
zoom = 9

m = new L.Map "map",
  center: center
  zoom: zoom
  layers: layer