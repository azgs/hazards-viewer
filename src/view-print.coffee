root = @
if not root.app? then app = root.app = {} else app = root.app
if not app.views? then app.views = views = {} else views = app.views

class views.PrintToolMapContainer extends Backbone.View
  render: ->
    @bounds = app.map.getBounds().toBBoxString()

    center = new L.LatLng 33.610044573695625, -111.50024414062501
    zoom = 9
    @previewMap = new L.Map "#map-container",
      center: center
      zoom: zoom
    $("#map-container").append @previewMap

    ###
    printArea = $("#map-container")
    $(map).clone(true,true).appendTo printArea
    newMap = $("#print-modal .modal-body #map").get(0)
    newMap.style.width = '700px'
    newMap.style.height = '600px'

    $("#print-modal .modal-body #map .leaflet-control-container .leaflet-top.leaflet-left").empty()
    $("#print-modal .modal-body #map").css "border","3px solid black"
    ###

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

    @bounds = app.map.getBounds().toBBoxString()

    center = new L.LatLng 33.610044573695625, -111.50024414062501
    zoom = 9
    @previewMap = new L.Map "preview-map-container",
      center: center
      zoom: zoom
    @previewMapDiv = $("#preview-map-container")
    @previewMapDiv.append @previewMap

    ###
    app.previewMap = new app.views.PrintToolMapContainer
    app.previewMap.render()
    ###

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