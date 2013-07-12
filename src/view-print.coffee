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
    @layer = @model.get "layer"
    @previewMap.addLayer @layer
    @model.set "active", true

    $("#preview-map-container").append @previewMap
    $("#preview-map-container .leaflet-control-container .leaflet-top.leaflet-left").empty()


  printMap: () ->
    ele = $("#print-area").html()
    htmlone = '<html><head>
      <link rel="stylesheet" href="vendor/leaflet/leaflet.css">
      <link rel="stylesheet" href="vendor/leaflet-draw/leaflet.draw.css">
      <link rel="stylesheet" href="styles/base.css">
      </head><body><div id="printable">'
    html2 = '</div></body></html>'
    string = htmlone + ele + html2

    document.body.innerHTML = string
    window.print()
    location.reload()

  resetMap: () ->
    @render()
    $(".modal-body").css
      "max-height": "400px"
    $(".modal").css
      "margin-left": "-280px"
      "top":"10%"