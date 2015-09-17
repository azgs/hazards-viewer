# 
#Original concept by Mapbox: 
#https://www.mapbox.com/mapbox.js/example/v1.0.0/filtering-markers/ 
#Tested with Leaflet v0.7.2.
#
#Vanilla leaflet only allows pre-filtering of json data.  This extension
#makes it possible to post-filter as well.
#
#Usage:
#
#var layer = L.filterGeoJson(data, options);
#
#layer.setFilter(function (f) {
#  return f.properties["lynyrd"] = "skynyrd";
#});

#OnClick (within popup) is a global event thus function must be pushed to global namespace    
(exports ? this).doZoom = (bbox0, bbox1, bbox2, bbox3) ->  
    bounds = L.latLngBounds([
      [
          bbox1
          bbox0
      ]
      [
        bbox3
        bbox2
      ]
    ])
    app.map.fitBounds bounds
    
#OnClick (within popup) is a global event thus function must be pushed to global namespace 
(exports ? this).windowPDF = () ->
    window.open(preview, '_blank')
  
  
L.FilterGeoJSON = L.FeatureGroup.extend(
  options:
    filter: ->
      true

  initialize: (data, options) ->
    L.setOptions this, options
    @_layers = {}
    @_style = options
    @setGeoJSON data  if data isnt null
    return

  addJSON: (data) ->
    @setGeoJSON data
    return

  setGeoJSON: (data) ->
    @_geojson = data
    @clearLayers()
    @filterize data
    this

  setFilter: (f) ->
    @options.filter = f
    if @_geojson
      @clearLayers()
      @filterize @_geojson
    this

  filterize: (json) ->
    f = (if L.Util.isArray(json) then json else json.features)
    i = undefined
    len = undefined
    if f
      i = 0
      while i < f.length
        @filterize f[i]  if f[i].geometries or f[i].geometry or f[i].features
        i++
    else if @options.filter(json)
      pointToLayer = @_style.pointToLayer
      layer = L.GeoJSON.geometryToLayer(json, pointToLayer)
      layer.feature = json

      date = json.properties.date

      props = [
        key: "Date"
        value: new Date(date)
      ]
      
      #Popup Configuration STUDY AREA/ Earth fissures  
      if json.properties.Type is "Study area" 
        url2 = 'http://data.azgs.az.gov/static/downloadable-files/hazard-data/'
        ###onEachFeature = (json, layer) ->###
        pdf = json.properties.Pdf.split(',')
        label = json.properties.Label
        bbox = layer.getBounds().toBBoxString()
        splitbbox = bbox.split(',')
        lastOne = pdf[pdf.length - 1]
        preview = url2 + 'EarthFissureAssets/' + lastOne + '.png'
        #PDF button/link 
        links = _.map(pdf, (item) ->
              path = url2 + 'EarthFissureAssets/' + item + '.pdf'
              '<div class="alert alert-info"><a Target="_blank" onclick="windowPDF" href="' + path + '">' + item + '</a></div>'
              ).join('')
        
        
        urlCheck = (url) ->
            http = new XMLHttpRequest
            http.open 'HEAD', url, false
            http.send()
            if http.status == 200
                        links
            else
                        '<div class="alert alert-danger">Not Available</div>'
        
        #zoom button / content in popup
        html1 = '<div class="title"><h4>' + label + ' Study Area</h4></div>'
        html1 += '<table><tr>'
        html1 += '<td width=200><img width=200 src="' + preview + '" onerror=this.style.display="none"; /></td>'
        html1 += '<td style="padding-left:10px;">'
        html1 += '<h5>Downloadable Maps:</h5>'
        html1 += '<div class=download>' + urlCheck(preview) + '</div>'
        html1 += '<button type="button" id="test" onclick="doZoom(' + bbox + ')" class="btn btn-success">Zoom to this study area</button>'
        html1 += '</td></tr></table>'
        
        layer.bindPopup html1, minWidth: 400
        @addLayer layer
        return
       
      else if isNaN json.properties.magnitude
        lookup = 
          I: "<strong>I.</strong> Not felt except by a very few under especially favorable conditions."
          II: "<strong>II.</strong> Felt only by a few persons at rest, especially on upper floors of buildings."
          III: "<strong>III.</strong> Felt quite noticeably by persons indoors, especially on upper floors of buildings. Many people do not recognize it as an earthquake. Standing motor cars may rock slightly. Vibrations similar to the passing of a truck. Duration estimated."
          IV: "<strong>IV.</strong> Felt indoors by many, outdoors by few during the day. At night, some awakened. Dishes, windows, doors disturbed; walls make cracking sound. Sensation like heavy truck striking building. Standing motor cars rocked noticeably."
          V: "<strong>V.</strong> Felt by nearly everyone; many awakened. Some dishes, windows broken. Unstable objects overturned. Pendulum clocks may stop."
          VI: "<strong>VI.</strong> Felt by all, many frightened. Some heavy furniture moved; a few instances of fallen plaster. Damage slight."
          VII: "<strong>VII.</strong> Damage negligible in buildings of good design and construction; slight to moderate in well-built ordinary structures; considerable damage in poorly built or badly designed structures; some chimneys broken."
          VIII: "<strong>VIII.</strong> Damage slight in specially designed structures; considerable damage in ordinary substantial buildings with partial collapse. Damage great in poorly built structures. Fall of chimneys, factory stacks, columns, monuments, walls. Heavy furniture overturned."
          IX: "<strong>IX.</strong> Damage considerable in specially designed structures; well-designed frame structures thrown out of plumb. Damage great in substantial buildings, with partial collapse. Buildings shifted off foundations."

        props.push
          key: "Intensity"
          value: "<p>#{lookup[json.properties.magnitude]}</p><p><a href='http://earthquake.usgs.gov/learn/topics/mercalli.php' target='_blank'>Read more about Intensity...</a></p>"
      else
        props.push
          key: "Magnitude"
          value: "#{json.properties.magnitude}"

      layer.bindPopup _.template $("#defaultPopup").html(),
        properties: props

      @addLayer layer
    return
    
)

L.filterGeoJson = (data, options) ->
  new L.FilterGeoJSON(data, options)
  
  