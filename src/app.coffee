# Setup a global object to stash our work in

root = @
if not root.app? then app = root.app = {} else app = root.app

# Deal with old browsers
app.views.badModalView({el: "body"}).render()

#Initialize the map
center = new L.LatLng 34.11180455556899, -111.7144775390625
zoom = 7

app.map = new L.Map "map",
  center: center
  zoom: zoom
  minZoom: 6
  maxZoom: 15

app.geoserverUrl = "http://data.azgs.az.gov/arizona-hazards/azgs/ows"

# Setup data layers
dataLayers = [
    new app.models.GeoJSONLayer
      id: "earthFissures"
      layerName: "Earth Fissures"
      serviceUrl: app.geoserverUrl
      serviceType: "WFS"
      typeName: "azgs:earthfissures"
      active: false
      useD3: true
      citation: "Arizona Geological Survey"
      details: '<p>Earth fissures are open surface fractures that may be as much as a mile in length, up to 15 ft wide, and 10s of feet deep. In Arizona, earth fissures form as a result of land subsidence driven by groundwater withdrawal. The Arizona Geological Survey has mapped and reported earth fissures throughout south-central and southeastern Arizona since the 1990s and published earth fissure study area maps in accordance with Arizona Revised Statute § 27-152.01(3) since 2007.  Mapping of fissures involves incorporating mapped earth fissures from previous studies, examining remotely sensed subsidence data and aerial imagery, and on-site field mapping using high-precision GPS receivers.</p><p>Between 2007 and 2012, AZGS identified 24 discreet areas throughout southern and central Arizona with concentrations of earth fissures totaling more than 150 miles of mapped fissures. These include uninterrupted open fissures and fissure gullies and discontinuous linear trends of potholes, abbreviated open cracks, elongated depressions, and other collapse features. An additional 180 miles of reported/unconfirmed earth fissures appear on AZGS maps. These features include fissures previously mapped by professional geologists appearing in published maps or figures which could not be confirmed through recent surface mapping by AZGS Geologists. </p><p>A reasonable effort was made to identify all earth fissures in the study area although some fissures may remain unmapped due to overprinting or disturbance by development, agricultural tilling, or lack of surface expression along the fissure at the time mapping was conducted. In addition, earth fissures are not static features. They may change in width, depth or length, and new fissures may appear after an area has been mapped. For these reasons the State of Arizona does not guarantee the maps are error free. Blank areas within study area boundaries have been investigated and no surface evidence of fissures was found as of the date of map publication.</p><p>For additional information on the origin and impacts of earth fissures and free PDF maps of earth fissure study areas, visit the <a href="http://www.azgs.az.gov/EFC.shtml">Arizona Geological Survey’s Earth Fissure Center</a>.</p>'
      brief: '<p>Earth fissures are open surface fractures that may be as much as a mile in length, up to 15 ft wide, and 10s of feet deep.</p><p>Earth fissure hazard data are currently unavailable for tribal lands in Arizona. To assess earth fissure hazards on tribal lands, please seek out further information from the appropriate Tribal Division of Public Safety Department or Environmental Protection.</p></p>'
      links: [
          text: "AZGS Earth Fissure Center"
          url: "http://www.azgs.az.gov/EFC.shtml"
        , 
          text: "Mitigation Tips"
          url: "mitigation/fissures.html"
      ]
      mitigationUrl: "mitigation/fissures.html"
      lastUpdate: "Summer, 2013"
      description: '<h4>Layer Description</h4>'
      legend: new app.models.Legend [
          caption: "Continuous Earth Fissure"
          attribute: "Label"
          value: "Continuous earth fissure"
          active: true
          imageInfo:
            png: "img/legend_imgs/png/ef_continuous.png"
        ,
          caption: "Discontinuous"
          attribute: "Label"
          value: "Discontinuous earth fissure"
          active: true
          imageInfo:
            png: "img/legend_imgs/png/ef_discontinuous.png"
        ,
          caption: "Reported/Unconfirmed"
          attribute: "Label"
          value: "Reported, unconfirmed earth fissure"
          active: true
          imageInfo:
            png: "img/legend_imgs/png/ef_reported.png"
      ],
        legendHeading: "Earth Fissure Type"
        heading: "Fissure Type"
      layerOptions:
        styler: "Label"
        style: (feature) ->
          defaultStyle =
            weight: 2
            fillOpacity: 0
            opacity: 1
            
          if feature.properties.Label is "Continuous earth fissure"
            defaultStyle.color = "black"
          if feature.properties.Label is "Discontinuous earth fissure"
            defaultStyle.color = "red"
          if feature.properties.Label is "Reported, unconfirmed earth fissure"
            defaultStyle.color = "green"
            defaultStyle.dashArray = "10 4"

          return defaultStyle
  ,
    new app.models.GeoJSONLayer
      id: "activeFaults"
      layerName: "Active Faults"
      serviceUrl: app.geoserverUrl
      serviceType: "WFS"
      typeName: "azgs:activefaults"
      active: false
      useD3: true
      citation: "Arizona Geological Survey"
      details: '<p>This layer summarizes available data on active Arizona faults. If faults have been active during the past 2.5 million years (Quaternary period), then we consider that there is some chance they could generate large earthquakes. Generally, the more active the fault zone is, the more likely it is to generate earthquakes, and earthquakes are more likely to occur in regions with many Quaternary faults.</p><p>These data were originally compiled in 1998 as part of an effort coordinated by the USGS to compile data and map information on Quaternary faults throughout the world. The database has recently been revised with much more accurate fault mapping, incorporation of new data on fault activity, and inclusion of additional fault zones, primarily in northern Arizona. This database depends heavily on several previous compilations of data on Quaternary faults in Arizona. The first and most comprehensive of these is the state-wide compilation of neotectonic faults by Menges and Pearthree (1983), supplemented by a state-wide compilation of young faults by Euge and others (1992). More detailed regional geologic maps provided most of the data in northern Arizona and southeastern Arizona. The database includes information from all detailed investigations of fault zones in Arizona.</p><p>The data structure is set up to provide systematic information on each fault zone. Fault names are based primarily on published maps or reports. In cases where different names have been used for the fault, the alternative names are listed within the database. All of the faults are listed by name and number in the table on the following page. This table indicates where the data summary for each fault can be found, as well as the age of youngest activity and fault slip rate category. The individual fault data sheets include information on map and data sources, fault location, geologic setting of the fault, the geomorphic expression of the fault, recency of fault movement, fault slip rate(s), and fault zone length and orientation. Faults are grouped into slip rate categories of <0.02 mm/yr, < 0.2 mm/yr, and <1 mm/yr. Most faults in Arizona fall into the lowest slip-rate category, with a few faults in the higher categories. Reported lengths are for the whole fault zone, not cumulative length of each individual fault in the zone, and orientations are averages for the fault zone.</p><p>Citations:</p><p>Euge, K.M., Schell, B.A. and Lam, I.P., 1992, Development of seismic acceleration maps for Arizona: Arizona Department of Transportation Report No. AZ92-344, 327 p., 5 sheets, scale 1:1,000,000. </p><p>Menges, C.M. and Pearthree, P.A., 1983, Map of neotectonic (latest Pliocene - Quaternary) deformation in Arizona: Arizona Bureau of Geology and Mineral Technology Open-File Report 83-22, 48 p., map scale 1:500,000, 4 map sheets.</p>'
      brief: 'Faults that are known to have been active within the last 2.5 million years (Quaternary period), and thus have some chance that they could generate a large earthquake.'
      links: []
      mitigationUrl: ""
      lastUpdate: "Fall, 2012"
      description: '<h4>Layer Description</h4>'
      legend: new app.models.Legend [
          caption: "Within 10,000 years"
          attribute: "symbol"
          value: "2.13.2"
          active: true
          imageInfo:
            png: "img/legend_imgs/png/af_10k.png"
        ,
          caption: "Within 750,000 years"
          attribute: "symbol"
          value: "2.13.3"
          active: true
          imageInfo:
            png: "img/legend_imgs/png/af_750k.png"
        ,
          caption: "Within 2.5 million years"
          attribute: "symbol"
          value: "2.13.4"
          active: true
          imageInfo:
            png: "img/legend_imgs/png/af_2m.png"
      ],
        legendHeading: "Active Faults Latest Motion"
        heading: "Most Recent Motion"
      layerOptions:
        styler: "symbol"
        style: (feature) ->
          defaultStyle =
            weight: 2
            fillOpacity: 0
            opacity: 1
          if feature.properties.symbol is "2.13.2"
            defaultStyle.color = "#FFA500"
          if feature.properties.symbol is "2.13.3"
            defaultStyle.color = "#008000"
          if feature.properties.symbol is "2.13.4"
            defaultStyle.color = "#800080"
          return defaultStyle
  ,
    new app.models.GeoJSONLayer
      id: "earthquakes"
      layerName: "Earthquake Epicenters"
      serviceUrl: app.geoserverUrl
      serviceType: "WFS"
      typeName: "azgs:earthquakedata"
      citation: "Arizona Geological Survey"
      details: '<p>The earthquakes displayed are from the AZGS Earthquake Catalog, and are the minimum number of earthquakes that have occurred in historical times.  Older events are represented by estimated Modified Mercalli Intensity Scale (MMI) roman-numeral values which reflect the amount of shaking experienced by those who felt and reported the earthquake. For a full description of the MMI scale, please refer to: <a href="http://earthquake.usgs.gov/learn/topics/mercalli.php">http://earthquake.usgs.gov/learn/topics/mercalli.php</a></p><p>The earthquake layer in the AZGS Hazard Viewer includes an epicentral location denoted in Latitude and Longitude, depth (in kilometers), date and time (UTC; -7:00 for MST). There are several magnitude scales employed to estimate the size (i.e., energy release) of an earthquake, such as Md - duration magnitude, ML - local magnitude, Mw - moment magnitude.  AZGS calculates duration magnitude, Md; however, the catalog includes all three types of magnitude scales depending on who located the event. For example, northern Arizona earthquakes located by the University of Utah are frequently assigned a local magnitude (Ml).  Sources of earthquake data reported in the AZGS Earthquake Catalog, include: AZGS (Arizona Geological Survey), USGS (United States Geological Survey), AEIC (Arizona Earthquake Information Center), UU (University of Utah), CI (California Integrated Seismic Network), and ASU (thesis work by Lockridge, Arizona State University). The earthquake layer does not include small magnitude events (< 2.0) because of the difficulty inherent in identifying and locating such events.</p>'
      brief: 'The earthquakes displayed are from the AZGS Earthquake Catalog, and are the minimum number of earthquakes that have occurred in the historical period dating to about 1850.'
      links: [
          text: "Description of Modified Mercalli Intensity Scale"
          url: "http://earthquake.usgs.gov/learn/topics/mercalli.php"
        , 
          text: "Mitigation Tips"
          url: "mitigation/earthquakes.html"
        ,
          text: "Arizona Emergency Information Network"
          url: "http://www.azein.gov/hazards/earthquakes"
      ]
      mitigationUrl: "mitigation/earthquakes.html"
      lastUpdate: "June 30, 2014"
      description: '<h4>Layer Description</h4>'
      filterClause: "&filter=#{(new app.models.Filter([{calculated_magnitude: "[2.0,9.0]"}])).urlEncoded()}"
      active: false
      legend: new app.models.Legend [
          caption: "Older Earthquakes"
          attribute: "magnitude"
          value: "contains(I,II,III,IV,V,VI,VII,VIII)"
          active: true
          imageInfo:
            png: "img/legend_imgs/png/eq_old.png"
        ,
          caption: "2 - 3"
          attribute: "magnitude"
          value: "[1.9, 3.1]"
          active: true
          imageInfo:
            png: "img/legend_imgs/png/eq_23.png"
        ,
          caption: "3 - 4"
          attribute: "magnitude"
          value: "[2.9, 4.1]"
          active: true
          imageInfo:
            png: "img/legend_imgs/png/eq_34.png"
        ,
          caption: "4 - 5"
          attribute: "magnitude"
          value: "[3.9, 5.1]"
          active: true
          imageInfo:
            png: "img/legend_imgs/png/eq_45.png"
        ,
          caption: "5 - 6"
          attribute: "magnitude"
          value: "[4.9, 6.1]"
          active: true
          imageInfo:
            png: "img/legend_imgs/png/eq_56.png"
        ,
          caption: "6 - 7"
          attribute: "magnitude"
          value: "[5.9, 7.1]"
          active: true
          imageInfo:
            png: "img/legend_imgs/png/eq_67.png"
        ,
          caption: "7 - 8"
          attribute: "magnitude"
          value: "[6.9, 8.1]"
          active: true
          imageInfo:
            png: "img/legend_imgs/png/eq_78.png"
      ],
        legendHeading: "Earthquake Magnitude"
        heading: "Magnitude"
      layerOptions:
        pointToLayer: (feature, latlng) ->
          markerOptions =
            fillOpacity: 0.2

          if isNaN Number feature.properties.magnitude
            markerOptions.size = 15
            markerOptions.color = markerOptions.fill = "#F24BE7"
            markerOptions.opacity = 1
            return new L.TriangleMarker [latlng], markerOptions

          mag = feature.properties.calculated_magnitude

          if 0 < mag <= 1 then color = "#FFFF00" # Dead yellow, hsl: 60,100,100
          else if 1 < mag <= 2 then color = "#FFDD00"
          else if 2 < mag <= 3 then color = "#FFBF00"
          else if 3 < mag <= 4 then color = "#FF9D00"
          else if 4 < mag <= 5 then color = "#FF8000"
          else if 5 < mag <= 6 then color = "#FF5E00"
          else if 6 < mag <= 7 then color = "#FF4000"
          else if 7 < mag <= 8 then color = "#FF0000" # Dead red, hsl: 0, 100, 100

          markerOptions.radius = mag * 5
          markerOptions.color = markerOptions.fillColor = color

          return L.circleMarker latlng, markerOptions
  ,
    new app.models.WmsLayer
      id: "floodPotential"
      layerName: "Flood Potential"
      serviceUrl: "http://data.azgs.az.gov/arizona-hazards/azgs/wms"
      serviceType: "WMS"
      wfsUrl: "http://data.azgs.az.gov/arizona-hazards/azgs/ows"
      typeName: "azgs:floods"
      active: false
      citation: "Arizona Division of Emergency Management"
      details: '<p>This layer shows areas with potentially High and Medium Risk of flooding. Data are drawn from the Federal Emergency Management Agency (FEMA) digital flood insurance rate maps (DFIRM) database, dated May 2010. High flooding potential includes areas covered by all of the “A” Special Flood Hazard zones. These areas have a 1% annual chance of flooding, also known as the 100-year flood, and a 26% chance of flooding within the span of a 30-year mortgage. Medium flood potential includes  areas within the “Shaded X” zones. These are areas between the limits of the 100-year and 500-year flood zones.</p><p>The flood potential layer was created by JE Fuller/Hydrology and Geomorpholgy, Inc. for the Arizona Division of Emergency Management (ADEM), as part of a larger study for the <a href="http://www.dem.azdema.gov/operations/mitigation/hazmitplan/hazmitplan.html">2010 State of Arizona Multi-Hazard Mitigation Plan</a>. Data is current as of May 2010. These data are provided as guidance only. Local Flood Control Districts should be consulted for additional or more detailed information.</p>'
      brief: '<p>Areas with High and Medium flooding potential as represented by the 100- and 500- flood zones determined by the Federal Emergency Management Agency (FEMA) digital flood insurance rate maps (DFIRM) database, dated May 2010.</p><p>Flood hazard data are currently unavailable for tribal lands in Arizona. To assess flood hazards on tribal lands, please seek out further information from the appropriate Tribal Division of Public Safety Department or Environmental Protection.</p>'
      links: [
          text: "2010 State of Arizona Multi-Hazard Mitigation Plan"
          url: "http://www.dem.azdema.gov/preparedness/docs/coop/mitplan/26_Flooding.pdf"
        , 
          text: "Mitigation Tips"
          url: "mitigation/floods.html"
        ,
          text: "Arizona Emergency Information Network"
          url: "http://www.azein.gov/hazards/flooding"
      ]
      mitigationUrl: "mitigation/floods.html"
      lastUpdate: "May, 2010"
      legend: new app.models.Legend [
          caption: "High"
          imageInfo:
            png: "img/legend_imgs/png/fp_high.png"
      ],
        legendHeading: "Flood Potential"
        heading: "Flood Potential"
        filterable: false
  ,
    new app.models.TileLayer
      id: "fireRisk"
      layerName: "Fire Risk Index"
      url: "http://{s}.tiles.usgin.org/fire-risk-index/{z}/{x}/{y}.png"
      serviceType: "WMS"
      opacity: 0.5,
      downloadUrlTemplate: "http://data.usgin.org/arizona/wcs?service=WCS&version=1.0.0&request=GetCoverage&coverage=fireriskindex&crs=epsg:4326&bbox={{bbox}}&format=GeoTIFF&resy=3.0495095356186517E-4&resx=3.0495095356186517E-4",
      citation: 'Oregon Department of Forestry, 2013, West Wide Wildfire Risk Assessment, final report, Prepared by the Sanborn Map Company.'
      details: '<p>The Fire Risk Index (FRI) layer, as shown here, depicts relative risks of areas susceptible to wildfires with 1 (dark green) representing the lowest risk and 9 (dark red) representing the highest risk. The data was developed through the West Wide Wildfire Risk Assessment (WWA) project to identify areas susceptible to wildfires in 17 western states and some U.S. affiliated Pacific Islands. The Oregon Department of Forestry (2013) implemented this project on behalf of the Council of Western State Foresters and the Western Forestry Leadership Coalition. The goal of the project was to provide a wildfire risk assessment appropriate for comparing areas at risks to wildfires across geographic regions, or within individual states, and to aid in mitigation of areas at risk, to identify the level of risks within communities and to communicate those risks to the public.</p><p>The FRI layer was created from the Fire Effect Index (FEI) and Fire Threat Index (FTI). FEI identifies areas that have important values at risk to wildfire and where wildland fires would be difficult and/or costly to suppress. FTI describes the likelihood of an acre burning and the expected final fire size based on conditions of fuels and potential fire behavior under different weather scenarios. FEI and FTI data were combined to create the FRI layer which describes relative probabilities of areas at risk to wildfires. The data used to develop FEI, FTI and FRI reflects conditions between 2008 and 2010, depending on the type of data (i.e. fuels, wildland development areas, and historic fire locations, etc.).</p><hr /><h4>Disclaimer</h4><p>The Oregon Department of Forestry implemented conducting this assessment on behalf of the Council of Western State Foresters with funding from the USDA Forest Service. Anyone utilizing this layer is asked to credit the Oregon Department of Forestry. Users must read and fully comprehend the metadata prior to data use. The spatial data to develop this layer were derived from a variety of sources. Care was taken in the creation of these themes, but they are provided "as is." The Oregon Department of Forestry, State of Oregon, WWA Project Partners, or any of the data providers cannot accept any responsibility for errors, omissions, or positional accuracy in the digital data or underlying records. There are no warranties, expressed or implied, including the warranty of merchantability or fitness for a particular purpose, accompanying any of these products.</p><p>The West Wide Risk Assessment was conducted to support strategic planning at regional, state, and landscape scale. WWA data is intended for planning purposes only and should not to be used for engineering or legal purposes. Further investigation by local and regional experts should be conducted to inform decisions regarding local applicability. It is the sole responsibility of the local user, using product metadata and local knowledge, to determine if and/or how WWA data can be used for particular areas of interest. It is the responsibility of the user to be familiar with the value, assumptions, and limitations of WWA products. Managers and planners must evaluate WWA data according to the scale and requirements specific to their needs. Please note that the WWA Published Results may not match other assessments conducted that use different data, technical methods, or scale of analysis. Having two assessments that do not match does not mean that either one of them is incorrect. The use of different data sources, often from different collection dates and with spatial accuracy and resolutions, combined with different modeling assumptions or definitions will result in different results and can have different interpretations and uses. The WWA results are not intended to replace local and state products as a decision-making tool. The WWA is meant to serve as a regional policy analysis tool that provides results comparable across geographic areas in the West.</p>',
      brief: 'Shows the relative risks of wildfire based on values at risk (i.e. development, infrastructure, etc.), the likelihood of an acre to burn, the expected final fire size based on fuels conditions and potential fire behavior and the difficulty or expense of suppression.'
      links: [ 
          text: "Mitigation Tips"
          url: "mitigation/fires.html"
        ,
          text: "Arizona Emergency Information Network"
          url: "http://www.azein.gov/hazards/wildfire"
      ]
      mitigationUrl: "mitigation/fires.html"
      lastUpdate: "Fall 2013"
      active: false
      legend: new app.models.Legend [
          caption: "Lowest"
          imageInfo:
            png: "img/legend_imgs/png/fri_1.png"
        ,
          caption: ""
          imageInfo:
            png: "img/legend_imgs/png/fri_2.png"
        ,
          caption: ""
          imageInfo:
            png: "img/legend_imgs/png/fri_3.png"
        ,
          caption: ""
          imageInfo:
            png: "img/legend_imgs/png/fri_4.png"
        ,
          caption: ""
          imageInfo:
            png: "img/legend_imgs/png/fri_5.png"
        ,
          caption: ""
          imageInfo:
            png: "img/legend_imgs/png/fri_6.png"
        ,
          caption: ""
          imageInfo:
            png: "img/legend_imgs/png/fri_7.png"
        ,
          caption: ""
          imageInfo:
            png: "img/legend_imgs/png/fri_8.png"
        ,
          caption: "Highest"
          imageInfo:
            png: "img/legend_imgs/png/fri_9.png"
      ],
        legendHeading: "FRI Relative Risk"
        heading: "Relative Risk"
        filterable: false
]
  
app.dataLayerCollection = new app.models.LayerCollection dataLayers

# Setup base layers
app.bingApiKey = "AvRe9bcvCMLvazRf2jV1W6FaNT40ABwWhH6gRYKxt72tgnoYwHV1BnWzZxbm7QJ2"
baseLayers = [
    new app.models.BingLayer
      id: "Road"
      layerName: "Road Map"
      apiKey: app.bingApiKey
      bingType: "Road"
      active: true
  ,
    new app.models.BingLayer
      id: "Aerial"
      layerName: "Satellite Imagery"
      apiKey: app.bingApiKey
      bingType: "Aerial"
  ,
    new app.models.BingLayer
      id: "AerialWithLabels"
      layerName: "Imagery with Labels"
      apiKey: app.bingApiKey
      bingType: "AerialWithLabels"
]

app.baseLayerCollection = new app.models.LayerCollection baseLayers

navTools = [
    new app.models.NavToolModel
      id: "print"
      toolName: "Print a Map"
      modalName: "Print a Map"
      modalBody: "Not Implemented Yet"
  ,
    new app.models.NavToolModel
      id: "export"
      toolName: "Download Data"
      modalName: "Download Data"
      modalBody: "Not Implemented Yet"
  ,
    new app.models.NavToolModel
      id: "mainHelp"
      toolName: "Help"
      modalName: "What Does All Of This Do?"
      modalBody: "Welcome to the Arizona Natural Hazards Viewer!  Whether you intended to come here or somehow ended up here accidentally, there's no better time than now to educate yourself about natural hazards in your area.  The main audience for this data viewer is intended to be people who normally don't have access to geo-scientific data/software.  We designed this help tutorial to educate users about what this data viewer does and how to do it.  If you're wondering what all of these fancy buttons do, click the blue 'Help!' button to take a tour!  If you have any feedback or questions, you can contact the Arizona Geological Survey at AZHazardViewer@azgs.az.gov."
]

app.navToolCollection = new app.models.NavToolCollection navTools

app.setHover = () -> $("#nav #menu .dropdown #dropmenu #AerialWithLabels-toggle").addClass "help-hover"
app.removeHover = () -> $("#nav #menu .dropdown #dropmenu #AerialWithLabels-toggle").removeClass "help-hover"
app.switchLayer = () -> $("#nav #menu .dropdown #dropmenu #AerialWithLabels-toggle").trigger "click"
app.toggleQuakes = () -> $("#earthquakes-toggle.layerToggle").trigger "click"

helpers = [
    new app.models.HelpModel
      id: "baselayers-help2"
      ele: $ "#nav #menu"
      head: "Main Navigation Menu"
      description: "This is the main navigation bar.  Clicking most of these buttons will generate a dialog box with further instructions on how to interact with the application.  For the sake of example, let's have a look at the 'Base Layers' button."
      placement: "bottom"
      action: () ->
        $(".tutorial-next").click () ->
          $(".dropdown-menu").css "display", "block"
  ,
    new app.models.HelpModel
      id: "baselayers-help"
      ele: $ "#nav #menu .dropdown #dropmenu"
      head: "Toggle Basemap Layers"
      description: "Basemap layers can be switched through this menu."
      placement: "right"
      action: () ->
        setTimeout app.setHover,1000
        setTimeout app.switchLayer,2000
        setTimeout app.removeHover,3000
        $(".tutorial-next").click () ->
          $(".dropdown-menu").css "display", ""
  ,
    new app.models.HelpModel
      id: "legend-help"
      ele: $ "#sidebar #layer-list"
      head: "Data Layer List"
      description: "Here is where you can interact with the data.  Click a button to switch a data layer 'on'.  Click a layer name to find out more information about a dataset."
      placement: "left"
      action: () ->
        setTimeout app.toggleQuakes,1000
  ,
    new app.models.HelpModel
      id: "menu-help"
      ele: $ "#sidebar"
      head: "Data Layer Legend"
      description: "Clicking a data layer 'on' will also generate a legend for that layer, where you can see how features on the map are symbolized.  Some data layers (like this one) support filtering within the dataset so that you can better focus what you are looking at."
      placement: "left"
      action: () -> 
        $(".tutorial-next").click () ->
          $("#earthquakes-toggle.layerToggle").trigger("click")
  ,
    new app.models.HelpModel
      id: "geocode-help"
      ele: $ "#nav #geocoder"
      head: "Geocoder"
      description: "Finally, you can enter a street address to discover local hazards in your area.  Upon pressing the 'enter' button on your keyboard, your address will be run through an algorithm which uses a 3 mile search radius to return natural hazards you should be aware about at a local level."
      placement: "bottom"
      action: () ->
        $("#nav #geocoder .search-query").val "416 W Congress St, Tucson, AZ 85701"
        app.geocodeViewHelp = new app.GeocodeView
          model: new app.GeocodeModel
            apiKey: app.bingApiKey
            value: $("#nav #geocoder .search-query").val()
          el: $ "#geocoder"
        app.geocodeViewHelp.geocode 
          keyCode: 13
]

app.helpersCollection = new app.models.HelpCollection helpers

# Render the sidebar
app.sidebar = new app.views.SidebarView
  el: $("#layer-list").first()
  collection: app.dataLayerCollection
app.sidebar.render()

# Render the base layer dropdown
app.baseLayers = new app.views.BasemapView
  el: $("#dropmenu").first()
  collection: app.baseLayerCollection
app.baseLayers.render()

# Render the Navbar tools
app.navbar = new app.views.NavToolView
  el: $ "body"
  collection: app.navToolCollection
app.navbar.render()

# Insert the print function
app.printFunction = new app.views.PrintToolView
  el: $ "#print-modal"
  collection: app.navToolCollection
app.printFunction.render()

# Setup the help tools
app.helperFunction = new app.views.HelpView
  el: $ "#mainHelp-modal"
  collection: app.helpersCollection
app.helperFunction.render()

# Insert the export modal body
app.exporter = new app.views.DownloadView
  el: $ "#export-modal"
  collection: app.dataLayerCollection
app.exporter.render()

# Setup the Geocoder
app.geocodeView = new app.GeocodeView
  model: new app.GeocodeModel
    apiKey: app.bingApiKey
  el: $ "#geocoder"

# Add a scalebar
app.map.addControl new L.Control.Scale()