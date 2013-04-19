app.editableLayers=new L.FeatureGroup()
app.map.addLayer app.editableLayers

options=
  position:"topleft"
  draw:
    polyline:
      title:"Draw a polyline"
      shapeOptions:
        color:"#33cc33"
        weight:5
    polygon:
      title:"Draw a polygon"
      allowIntersection:false
      drawError:
        color:"#ff0000"
        message:"Sorry!  You can only draw simple polygons!"
      shapeOptions:
        color:"#33cc33"
        weight:5
    rectangle:
      title:"Draw a rectangle"
      shapeOptions:
        color:"#33cc33"
        weight:5        
    circle:
      title:"Draw a circle"
      shapeOptions:
        color:"#33cc33"
        weight:5       
    marker:
      title:"Add a marker"
      icon:L.Icon.Default()
  edit:
    featureGroup:app.editableLayers      

app.drawControl=new L.Control.Draw options
app.map.addControl app.drawControl