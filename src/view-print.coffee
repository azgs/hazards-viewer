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
      closeBtn = '<button id="close-btn" data-dismiss="modal" aria-hidden="true" class="btn">Close</button>'
      previewBtn = '<button id="preview-btn" class="btn btn-primary">Preview</button>'
    ]

    newButtons.forEach (button) ->
      $("#print-modal .modal-footer").append(button)

  events: ->
    "click #preview-btn":"structureModal"
    "click #print-btn":"printMap"
    "click #close-btn":"resetMap"

  structureModal: () ->
    printContainer = @printContainer
    @modalBody = $("#print-modal .modal-body")
    @modalBody.empty().append printContainer
    $("#print-modal .modal-header").remove()

    $("#preview-btn").replaceWith "<button id='print-btn' class='btn btn-primary'>Print</button>"

    $(".modal").css
      "margin-left": "-35%"
      "top":"2%"
    $(".modal-body").css
      "max-height": "700px"
    $("#legend-container").css
      "max-height": "600px"

    div = $("#print-modal").get(0)
    div.style.width = '1000px'

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

    $("#legend-container .legend-item-symbol .legend-image-symbol img").css "height",20
    $("#legend-container .legend-item-symbol .legend-image-symbol img").css "height",20
    $("#legend-container .legend-item-fisstype .legend-image-fisstype img").css "height",20
    $("#legend-container .legend-item-fisstype .legend-image-fisstype img").css "height",20
    $("#legend-container .legend-item-magnitude .legend-image-magnitude img").css "height",20
    $("#legend-container .legend-item-magnitude .legend-image-magnitude img").css "height",20


  printMap: () ->
    ele = $("#print-modal .modal-body")
    ele.focus()
    window.print()

  resetMap: () ->
    $("#print-modal").modal("hide")
    @render()
    #$("#print-modal .modal-body").css
    #  "height": "100px"
    #  "width": "560px"
    #$(".modal").css
    #  "margin-left": "-280px"
    #  "top":"10%"