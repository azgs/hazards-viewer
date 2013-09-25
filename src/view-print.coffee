root = @
if not root.app? then app = root.app = {} else app = root.app
if not app.views? then app.views = views = {} else views = app.views

class views.PrintPreviewView extends Backbone.View
  initialize: (options) ->
    @template = _.template $("#print-preview-container-modal").html()

  render: () ->
    @$el.append @template()
    modal = @$el.find("#print-preview-modal").modal()
    modal.on 'shown', () ->
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

    modal.modal 'show'
    return @

  events: ->
    "click #print-btn":"printMap"
    "click #reset-btn":"resetMap"

  printMap: () ->
    ele = $("#print-preview-modal .modal-body")
    ele.focus()
    window.print()

  resetMap: () ->
    $("#print-preview-modal").modal "hide"
    $("#print-preview-modal").remove()

app.views.printPreview = (options) ->
  new app.views.PrintPreviewView options

class views.PrintToolView extends Backbone.View
  initialize: ->
    @printTemplate = _.template $("#print-tool").html()
  
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

  structureModal: () ->
    $("#print-modal").modal "hide"
    app.tempmap = app.views.printPreview({el: "body"}).render()