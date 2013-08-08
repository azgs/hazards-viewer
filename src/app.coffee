# Setup a global object to stash our work in
root = @
if not root.app? then app = root.app = {} else app = root.app

#Initialize the map
center = new L.LatLng 34.11180455556899, -111.7144775390625
zoom = 7

app.map = new L.Map "map",
  center: center
  zoom: zoom
  minZoom: 7
  maxZoom: 13

app.geoserverUrl = "http://data.usgin.org/arizona/ows"

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
      description: '<h4>Layer Description</h4><p>Earth fissures are open surface fractures that may be as much as a mile in length, up to 15 ft wide, and 10s of feet deep. In Arizona, earth fissures form as a result of land subsidence driven by groundwater withdrawal. The Arizona Geological Survey has mapped and reported earth fissures throughout south-central and southeastern Arizona since the 1990s and published earth fissure study area maps in accordance with Arizona Revised Statute § 27-152.01(3) since 2007.  Mapping of fissures involves incorporating mapped earth fissures from previous studies, examining remotely sensed subsidence data and aerial imagery, and on-site field mapping using high-precision GPS receivers.</p><p>Between 2007 and 2012, AZGS identified 24 discreet areas throughout southern and central Arizona with concentrations of earth fissures totaling more than 150 miles of mapped fissures. These include uninterrupted open fissures and fissure gullies and discontinuous linear trends of potholes, abbreviated open cracks, elongated depressions, and other collapse features. An additional 180 miles of reported/unconfirmed earth fissures appear on AZGS maps. These features include fissures previously mapped by professional geologists appearing in published maps or figures which could not be confirmed through recent surface mapping by AZGS Geologists. </p><p>A reasonable effort was made to identify all earth fissures in the study area although some fissures may remain unmapped due to overprinting or disturbance by development, agricultural tilling, or lack of surface expression along the fissure at the time mapping was conducted. In addition, earth fissures are not static features. They may change in width, depth or length, and new fissures may appear after an area has been mapped. For these reasons the State of Arizona does not guarantee the maps are error free. Blank areas within study area boundaries have been investigated and no surface evidence of fissures was found as of the date of map publication.</p><p>For additional information on the origin and impacts of earth fissures and free PDF maps of earth fissure study areas, visit the <a href="http://www.azgs.az.gov/EFC.shtml">Arizona Geological Survey’s Earth Fissure Center</a>.</p>'
      legend: new app.models.Legend [
          caption: "Continuous Earth Fissure"
          attribute: "fisstype"
          value: "Continuous Earth Fissure"
          imageTemplateId: "fissureImage"
          active: true
          imageInfo:
            color: "#000000"
        ,
          caption: "Discontinuous Earth Fissure"
          attribute: "fisstype"
          value: "Discontinuous Earth Fissure"
          imageTemplateId: "fissureImage"
          active: true
          imageInfo:
            color: "#FF0000"
        ,
          caption: "Reported, Unconfirmed Earth Fissure"
          attribute: "fisstype"
          value: "Reported, Unconfirmed Earth Fissure"
          imageTemplateId: "fissureImage"
          active: true
          imageInfo:
            color: "#008000"
            dashed: "10 4"
      ],
        legendHeading: "Earth Fissure Type"
        heading: "Fissure Type"
      layerOptions:
        styler: "fisstype"
  ,
    new app.models.GeoJSONLayer
      id: "activeFaults"
      layerName: "Active Faults"
      serviceUrl: app.geoserverUrl
      serviceType: "WFS"
      typeName: "azgs:activefaults"
      active: false
      useD3: true
      description: '<h4>Layer Description</h4><p>This layer summarizes available data on active Arizona faults. If faults have been active during the past 2.5 million years (Quaternary period), then we consider that there is some chance they could generate large earthquakes. Generally, the more active the fault zone is, the more likely it is to generate earthquakes, and earthquakes are more likely to occur in regions with many Quaternary faults.</p><p>These data were originally compiled in 1998 as part of an effort coordinated by the USGS to compile data and map information on Quaternary faults throughout the world. The database has recently been revised with much more accurate fault mapping, incorporation of new data on fault activity, and inclusion of additional fault zones, primarily in northern Arizona. This database depends heavily on several previous compilations of data on Quaternary faults in Arizona. The first and most comprehensive of these is the state-wide compilation of neotectonic faults by Menges and Pearthree (1983), supplemented by a state-wide compilation of young faults by Euge and others (1992). More detailed regional geologic maps provided most of the data in northern Arizona and southeastern Arizona. The database includes information from all detailed investigations of fault zones in Arizona.</p><p>The data structure is set up to provide systematic information on each fault zone. Fault names are based primarily on published maps or reports. In cases where different names have been used for the fault, the alternative names are listed within the database. All of the faults are listed by name and number in the table on the following page. This table indicates where the data summary for each fault can be found, as well as the age of youngest activity and fault slip rate category. The individual fault data sheets include information on map and data sources, fault location, geologic setting of the fault, the geomorphic expression of the fault, recency of fault movement, fault slip rate(s), and fault zone length and orientation. Faults are grouped into slip rate categories of <0.02 mm/yr, < 0.2 mm/yr, and <1 mm/yr. Most faults in Arizona fall into the lowest slip-rate category, with a few faults in the higher categories. Reported lengths are for the whole fault zone, not cumulative length of each individual fault in the zone, and orientations are averages for the fault zone.</p><p>Citations:</p><p>Euge, K.M., Schell, B.A. and Lam, I.P., 1992, Development of seismic acceleration maps for Arizona: Arizona Department of Transportation Report No. AZ92-344, 327 p., 5 sheets, scale 1:1,000,000. </p><p>Menges, C.M. and Pearthree, P.A., 1983, Map of neotectonic (latest Pliocene - Quaternary) deformation in Arizona: Arizona Bureau of Geology and Mineral Technology Open-File Report 83-22, 48 p., map scale 1:500,000, 4 map sheets.</p>'
      legend: new app.models.Legend [
          caption: "Holocene ( <10 ka )"
          attribute: "symbol"
          value: "2.13.2"
          imageTemplateId: "faultImage"
          active: true
          imageInfo:
            color: "#FFA500"
        ,
          caption: "Late Quaternary ( <750 ka )"
          attribute: "symbol"
          value: "2.13.3"
          imageTemplateId: "faultImage"
          active: true
          imageInfo:
            color: "#008000"
        ,
          caption: "Quaternary (Undifferentiated)"
          attribute: "symbol"
          value: "2.13.4"
          imageTemplateId: "faultImage"
          active: true
          imageInfo:
            color: "#800080"
      ],
        legendHeading: "Active Faults Latest Motion"
        heading: "Latest Motion"
      layerOptions:
        styler: "symbol"
  ,
    new app.models.GeoJSONLayer
      id: "earthquakes"
      layerName: "Earthquake Epicenters"
      serviceUrl: app.geoserverUrl
      serviceType: "WFS"
      typeName: "azgs:earthquakedata"
      description: '<h4>Layer Description</h4><p>The earthquakes displayed are from the AZGS Earthquake Catalog, and are the minimum number of earthquakes that have occurred in historical times.  Older events are represented by estimated Modified Mercalli Intensity Scale (MMI) roman-numeral values which reflect the amount of shaking experienced by those who felt and reported the earthquake. For a full description of the MMI scale, please refer to: <a href="http://earthquake.usgs.gov/learn/topics/mercalli.php">http://earthquake.usgs.gov/learn/topics/mercalli.php</a></p><p>The earthquake layer in the AZGS Hazard Viewer includes an epicentral location denoted in Latitude and Longitude, depth (in kilometers), date and time (UTC; -7:00 for MST). There are several magnitude scales employed to estimate the size (i.e., energy release) of an earthquake, such as Md - duration magnitude, ML - local magnitude, Mw - moment magnitude.  AZGS calculates duration magnitude, Md; however, the catalog includes all three types of magnitude scales depending on who located the event. For example, northern Arizona earthquakes located by the University of Utah are frequently assigned a local magnitude (Ml).  Sources of earthquake data reported in the AZGS Earthquake Catalog, include: AZGS (Arizona Geological Survey), USGS (United States Geological Survey), AEIC (Arizona Earthquake Information Center), UU (University of Utah), CI (California Integrated Seismic Network), and ASU (thesis work by Lockridge, Arizona State University). The earthquake layer does not include small magnitude events (< 2.0) because of the difficulty inherent in identifying and locating such events.</p>'
      filterClause: "&filter=#{(new app.models.Filter([{calculated_magnitude: "[2.0,9.0]"}])).urlEncoded()}"
      active: false
      legend: new app.models.Legend [
          caption: "Older Earthquakes"
          attribute: "magnitude"
          value: "contains(I,II,III,IV,V,VI,VII,VIII)"
          imageTemplateId: "quakeIntensityImage"
          active: true
        ,
          caption: "2 - 3"
          attribute: "magnitude"
          value: "[1.9, 3.1]"
          imageTemplateId: "quakeImage"
          active: true
          imageInfo:
            radius: 15
            color: "#FFBF00"
        ,
          caption: "3 - 4"
          attribute: "magnitude"
          value: "[2.9, 4.1]"
          imageTemplateId: "quakeImage"
          active: true
          imageInfo:
            radius: 20
            color: "#FF9D00"
        ,
          caption: "4 - 5"
          attribute: "magnitude"
          value: "[3.9, 5.1]"
          imageTemplateId: "quakeImage"
          active: true
          imageInfo:
            radius: 25
            color: "#FF8000"
        ,
          caption: "5 - 6"
          attribute: "magnitude"
          value: "[4.9, 6.1]"
          imageTemplateId: "quakeImage"
          active: true
          imageInfo:
            radius: 30
            color: "#FF5E00"
        ,
          caption: "6 - 7"
          attribute: "magnitude"
          value: "[5.9, 7.1]"
          imageTemplateId: "quakeImage"
          active: true
          imageInfo:
            radius: 35
            color: "#FF4000"
        ,
          caption: "7 - 8"
          attribute: "magnitude"
          value: "[6.9, 8.1]"
          imageTemplateId: "quakeImage"
          active: true
          imageInfo:
            radius: 40
            color: "#FF0000"
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

        onEachFeature: (feature, layer) ->
          layer.bindPopup feature.properties.magnitude
  ,
    new app.models.WmsLayer
      id: "floodPotential"
      layerName: "Flood Potential"
      serviceUrl: "http://data.usgin.org/arizona/gwc/service/wms"
      serviceType: "WMS"
      wfsUrl: "http://data.usgin.org/arizona/ows"
      typeName: "azgs:floods"
      active: false
      description: '<h4>Layer Description</h4><p>This layer shows areas with potentially High and Medium Risk of flooding. Data are drawn from the Federal Emergency Management Agency (FEMA) digital flood insurance rate maps (DFIRM) database, dated May 2010. High flooding potential includes areas covered by all of the “A” Special Flood Hazard zones. These areas have a 1% annual chance of flooding, also known as the 100-year flood, and a 26% chance of flooding within the span of a 30-year mortgage. Medium flood potential includes  areas within the “Shaded X” zones. These are areas between the limits of the 100-year and 500-year flood zones.</p><p>The flood potential layer was created by JE Fuller/Hydrology and Geomorpholgy, Inc. for the Arizona Division of Emergency Management (ADEM), as part of a larger study for the 2010 State of Arizona Multi-Hazard Mitigation Plan (http://www.dem.azdema.gov/operations/mitigation/hazmitplan/hazmitplan.html). Data is current as of May 2010. These data are provided as guidance only. Local Flood Control Districts should be consulted for additional or more detailed information.</p>'
      legend: new app.models.Legend [
          caption: "High"
          imageTemplateId: "floodImage"
          imageInfo:
            color: "#0039BF"
        ,
          caption: "Medium"
          imageTemplateId: "floodImage"
          imageInfo:
            color: "#6FCFF7"
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
      description: '<h4>Layer Description</h4><p>The Fire Risk Index (FRI) layer, as shown here, depicts relative risks of areas susceptible to wildfires with 1 (dark green) representing the lowest risk and 9 (dark red) representing the highest risk. The data was developed through the West Wide Wildfire Risk Assessment (WWA) project to identify areas susceptible to wildfires in 17 western states and some U.S. affiliated Pacific Islands. The Oregon Department of Forestry (2013) implemented this project on behalf of the Council of Western State Foresters and the Western Forestry Leadership Coalition. The goal of the project was to provide a wildfire risk assessment appropriate for comparing areas at risks to wildfires across geographic regions, or within individual states, and to aid in mitigation of areas at risk, to identify the level of risks within communities and to communicate those risks to the public.</p><p>The FRI layer was created from the Fire Effect Index (FEI) and Fire Threat Index (FTI). FEI identifies areas that have important values at risk to wildfire and where wildland fires would be difficult and/or costly to suppress. FTI describes the likelihood of an acre burning and the expected final fire size based on conditions of fuels and potential fire behavior under different weather scenarios. FEI and FTI data were combined to create the FRI layer which describes relative probabilities of areas at risk to wildfires. The data used to develop FEI, FTI and FRI reflects conditions between 2008 and 2010, depending on the type of data (i.e. fuels, wildland development areas, and historic fire locations, etc.).</p><p>Disclaimer</p><p>The Oregon Department of Forestry implemented conducting this assessment on behalf of the Council of Western State Foresters with funding from the USDA Forest Service. Anyone utilizing this layer is asked to credit the Oregon Department of Forestry. Users must read and fully comprehend the metadata prior to data use. The spatial data to develop this layer were derived from a variety of sources. Care was taken in the creation of these themes, but they are provided "as is." The Oregon Department of Forestry, State of Oregon, WWA Project Partners, or any of the data providers cannot accept any responsibility for errors, omissions, or positional accuracy in the digital data or underlying records. There are no warranties, expressed or implied, including the warranty of merchantability or fitness for a particular purpose, accompanying any of these products.</p><p>The West Wide Risk Assessment was conducted to support strategic planning at regional, state, and landscape scale. WWA data is intended for planning purposes only and should not to be used for engineering or legal purposes. Further investigation by local and regional experts should be conducted to inform decisions regarding local applicability. It is the sole responsibility of the local user, using product metadata and local knowledge, to determine if and/or how WWA data can be used for particular areas of interest. It is the responsibility of the user to be familiar with the value, assumptions, and limitations of WWA products. Managers and planners must evaluate WWA data according to the scale and requirements specific to their needs. Please note that the WWA Published Results may not match other assessments conducted that use different data, technical methods, or scale of analysis. Having two assessments that do not match does not mean that either one of them is incorrect. The use of different data sources, often from different collection dates and with spatial accuracy and resolutions, combined with different modeling assumptions or definitions will result in different results and can have different interpretations and uses. The WWA results are not intended to replace local and state products as a decision-making tool. The WWA is meant to serve as a regional policy analysis tool that provides results comparable across geographic areas in the West.</p><p>Citation</p><p>Oregon Department of Forestry, 2013, West Wide Wildfire Risk Assessment, final report, Prepared by the Sanborn Map Company.</p>',
      active: false
      legend: new app.models.Legend [
          caption: "Lowest"
          imageTemplateId: "fireImage"
          imageInfo:
            color: "rgb(130,160,104)"
        ,
          caption: ""
          imageTemplateId: "fireImage"
          imageInfo:
            color: "rgb(177,207,158)"
        ,
          caption: ""
          imageTemplateId: "fireImage"
          imageInfo:
            color: "rgb(205,197,138)"
        ,
          caption: ""
          imageTemplateId: "fireImage"
          imageInfo:
            color: "rgb(255,255,175)"
        ,
          caption: ""
          imageTemplateId: "fireImage"
          imageInfo:
            color: "rgb(254,202,104)"
        ,
          caption: ""
          imageTemplateId: "fireImage"
          imageInfo:
            color: "rgb(253,154,8)"
        ,
          caption: ""
          imageTemplateId: "fireImage"
          imageInfo:
            color: "rgb(251,61,8)"
        ,
          caption: ""
          imageTemplateId: "fireImage"
          imageInfo:
            color: "rgb(193,0,6)"
        ,
          caption: "Highest"
          imageTemplateId: "fireImage"
          imageInfo:
            color: "rgb(95,0,2)"
      ],
        legendHeading: "FRI Relative Risk"
        heading: "Relative Risk"
        filterable: false
]

###,
  new app.models.TileLayer
    id: "femaFloods"
    layerName: "FEMA Flood Hazards"
    url: "http://atlas.resources.ca.gov/arcgis/rest/services/GeoScience/Flood_Risk_FEMA/MapServer/tile/{z}/{y}/{x}"
    downloadUrlTemplate: "problematic"
    description: '<h4>Layer Description</h4><p>Senate Bill 5 (SB 5), which was enacted in 2007, authorized the California Department of Water Resources (DWR) to develop the Best Available Maps (BAM) displaying 100- and 200-year floodplains for areas located within the Sacramento-San Joaquin (SAC-SJ) Valley watershed. SB 5 requires that these maps contain the best available information on flood hazards and be provided to cities and counties in the SAC-SJ Valley watershed. This effort was completed by DWR in 2008. DWR has expanded the BAM to cover all counties in the State and to include 500-year floodplains.. The 100-, 200-, and 500-year floodplains are displayed on this web viewer. The web viewer allows users to view a particular area and identify their potential flood hazards. The following is a comprehensive list of the floodplains that are displayed on the web viewer and may be updated periodically. * 100-Year Floodplains * Federal Emergency Management Agency (FEMA )Digital Flood Insurance Rate Map (DFIRM) * Effective * Preliminary * FEMA Q3 Effective Flood Data (for areas lacking Effective DFIRM coverage) * DWR Awareness Mapping * United States Army Corps of Engineers (USACE) Sacramento and San Joaquin River Basins Comprehensive Study * Regional/Special Studies * 200-Year Floodplains * USACE Sacramento and San Joaquin River Basins Comprehensive Study * 500-Year Floodplains (for web viewer) * FEMA DFIRM * Effective * Preliminary * FEMA Q3 Effective Flood Data (for areas lacking Effective DFIRM coverage) * USACE Sacramento and San Joaquin River Basins Comprehensive Study * Regional/Special Studies Disclaimer The BAM does not replace existing FEMA regulatory floodplains shown on Flood Insurance Rate Maps (FIRM). For more information on the FEMA regulatory floodplains, please contact FEMA directly. The BAM floodplains identify potential flood risks that may warrant further studies or analyses for land use decision making. The floodplains shown delineate areas with potential exposure to flooding for three different storm events: one with storm flows that have a 1% chance of being equaled or exceeded in any year (100-year), one with storm flows that have a 0.5% chance of being equaled or exceeded in any year (200-year), and one with storms flows that have a 0.2% chance of being equaled or exceeded in any year (500-year). These flows and resulting flooded area are based on the best available floodplain information and may not identify all areas subject to flooding.</p><p>Copyright © <a href="http://www.fema.gov/index.shtm">FEMA</a></p>'
    legend: new app.models.Legend [], { heading: "TBD", filterable: false }
###
  
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

###
  new app.models.NavToolModel
    id: "addLayer"
    toolName: "Add Layer"
    modalName: "Add a Layer"
    modalBody: "Not Implemented Yet"
,
###

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
      modalName: "How Do I Do This?"
      modalBody: "Not Implemented Yet"
]

app.navToolCollection = new app.models.NavToolCollection navTools

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
