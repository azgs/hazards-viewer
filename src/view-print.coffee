root = @
if not root.app? then app = root.app = {} else app = root.app
if not app.views? then app.views = views = {} else views = app.views

class views.PrintToolView extends Backbone.View
  initialize: ->
    @printTemplate = _.template $("#print-tool").html()
    @printContainer = _.template $("#print-container").html()

  render: ->
    printTemplate = @printTemplate
    domEls = [
      @printBody = @$el.find ".modal-body"
      printFooter = @$el.find ".modal-footer"
    ]

    domEls.forEach (el) ->
      el.empty()

    @printBody.append printTemplate

    @collection.forEach (model) ->
      if model.get "print"
        printBody.append printTemplate
          model: model

    newButtons = [
      resetBtn = '<button id="reset-btn" class="btn" style="float:left;">Reset</button>'
      closeBtn = '<button id="close-btn" data-dismiss="modal" aria-hidden="true" class="btn">Close</button>'
      previewBtn = '<button id="preview-btn" class="btn btn-primary">Preview</button>'
    ]

    newButtons.forEach (button) ->
      $("#print-modal .modal-footer").append(button)

  events: ->
    "click #preview-btn":"structureModal"
    "click #print-btn":"printMap"
    "click #reset-btn":"resetMap"

  structureModal: () ->
    printContainer = @printContainer
    @modalBody = $("#print-modal .modal-body")
    @modalBody.empty().append printContainer

    $("#preview-btn").replaceWith "<button id='print-btn' class='btn btn-primary'>Print</button>"

    $(".modal").css
      "margin-left": "-540px"
      "top":"5%"
    $(".modal-body").css
      "max-height": "400px"

    div = $("#print-modal").get(0)
    body = $("#print-modal .modal-body").get(0)
    div.style.width = '1000px'
    body.style.height = '600px'

    $('input[name="title"]').change ->
      @value = $('input[name="title"]').val()
      $("#preview-map-container").before "<p id='title' style='text-align:left; font-size:20px; font-weight:bold;'></p>"
      $("#title").append @value
      $("#title-input").remove()

    @bounds = app.map.getBounds()
    @center = app.map.getCenter()
    @zoom = app.map.getZoom()

    @previewMap = new L.Map "preview-map-container",
      center: @center
      zoom: @zoom
    @previewMap.setMaxBounds @bounds
    @previewMap.addControl new L.Control.Scale()

    @model = app.baseLayers.findActiveModel()
    @layer = @model.createLayer(@model.originalOptions)
    @previewMap.addLayer @layer
    @model.set "active", true

    @activeLayers = app.sidebar.findActiveLayers()

    for layer in @activeLayers
      @layer = layer
      @layerLegend = @layer.get "legend"
      @service = @layer.get "serviceType"
      @d3 = @layer.get "useD3"
      if @service is "WFS" and not @d3
        @layerData = @layer.get "currentData"
        @layerOptions = @layer.originalOptions.layerOptions
        new L.GeoJSON(@layerData, @layerOptions).addTo @previewMap
      else if @service is "WFS" and @d3
        @layerData = @layer.get "currentData"
        @layerOptions = @layer.originalOptions.layerOptions
        new L.GeoJSON.d3(@layerData, @layerOptions).addTo @previewMap
      else
        @wms = @layer.createLayer(@layer.originalOptions)
        @previewMap.addLayer @wms

    $("#preview-map-container .leaflet-control-container .leaflet-top.leaflet-left").empty()

    @legend = $("#legend-container")
    for layer in @activeLayers
      @layer = layer
      printLegend = new views.PrintLegendView
        layerModel: @layer
        collection: @layer.get "legend"
        el: @legend
      printLegend.render()

    $("#legend-container .legendItems .legend-item-calculated_magnitude circle").attr "r",6
    $("#legend-container .legendItems .legend-item-calculated_magnitude circle").attr "cx",10
    $("#legend-container .legendItems .legend-item-calculated_magnitude circle").attr "cy",9
    $("#legend-container .legendItems .legend-item-calculated_magnitude svg").css "height",16

    $("#legend-container .legendItems .legend-item-activefaults path").attr "d", "M 5 20 q 10 -30 20 -10"
    $("#legend-container .legendItems .legend-item-activefaults svg").css "height",20

    $("#legend-container .legendItems .legend-item-fisstype path").attr "d", "M 5 20 q 10 -30 20 -10"
    $("#legend-container .legendItems .legend-item-fisstype svg").css "height",20

    $("#legend-container .legendItems .legend-item-symbol .legend-image-symbol path").attr "d", "M 5 5 L 25 5 L 25 25 L 5 25 L 5 5"
    $("#legend-container .legendItems .legend-item-symbol .legend-image-symbol svg").css "height", 25

  printMap: () ->
    ele = $("#print-container").html()
    htmlone = '<html><head>
      <link rel="stylesheet" href="vendor/leaflet/leaflet.css">
      <link rel="stylesheet" href="vendor/leaflet-draw/leaflet.draw.css">
      <link rel="stylesheet" href="styles/base.css">
      </head><body>'
    html2 = '</div></body></html>'
    string = htmlone + ele + html2

    document.body.innerHTML = string
    #window.print()
    #location.reload()

  resetMap: () ->
    @render()
    $(".modal-body").css
      "max-height": "400px"
    $(".modal").css
      "margin-left": "-280px"
      "top":"10%"