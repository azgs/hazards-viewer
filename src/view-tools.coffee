# Setup a global object to stash our work in
root = @
if not root.app? then app = root.app = {} else app = root.app
if not app.views? then app.views = views = {} else views = app.views

class views.NavToolView extends Backbone.View
  initialize: ->
    @buttonTemplate = _.template $("#navbar-button").html()
    @modalTemplate = _.template $("#navbar-modal").html()

  render: ->
    body = @$el
    navbar = $ "#menu"

    buttonTemplate = @buttonTemplate
    modalTemplate = @modalTemplate

    @collection.forEach (model) ->
      body.append modalTemplate
        model: model
      navbar.append buttonTemplate
        model: model

class views.PrintToolView extends Backbone.View
  initialize: ->
    @printTemplate = _.template $("#print-tool").html()
    $("#print-modal .modal-body").empty()
    $("#print-modal .modal-footer").empty()
    newButtons = [
      previewBtn = '<button id="preview-btn" class="btn">Preview</button>'
      titleBtn = '<button id="title-btn" class="btn">Title</button>'
      closeBtn = '<button id="close-btn" data-dismiss="modal" aria-hidden="true" class="btn">Close</button>'
      printBtn = '<button id="print-btn" class="btn btn-primary">Print</button>'
    ]
    newButtons.forEach (button) ->
      $("#print-modal .modal-footer").append(button)

  render: ->
    printBody = @$el.find ".modal-body"
    printTemplate = @printTemplate

    @collection.forEach (model) ->
      if model.get "print"
        printBody.append printTemplate
          model: model

  events: ->
    "click #preview-btn":"previewMap"
    "click #print-btn":"printMap"
    "click #close-btn":"resetMap"
    "click #title-btn":"insertTitle"

  previewMap: () ->
    $("#print-modal .modal-body").empty()
    $(".modal").css
      "margin-left": "-540px"
      "top":"5%"
    $(".modal-body").css
      "max-height": "400px"
    domEl = $("#map")


    height = $("#map").height()
    width = $("#map").width()
    mDiv = $("#print-modal").get(0)
    mBody = $("#print-modal .modal-body").get(0)
    $(mBody).append "<div id='print-area'></div>"
    printArea = $("#print-area")
    mDiv.style.width = (width+100) + 'px'
    mBody.style.height = height + 'px'
    $(domEl).clone(true,true).appendTo printArea
    newMap = $("#print-modal .modal-body #map").get(0)
    $("#print-modal .modal-body #map .leaflet-control-container .leaflet-top.leaflet-left").empty()
    newMap.style.width = '700px'
    newMap.style.height = '600px'
    $("#print-modal .modal-body #map").css "border","3px solid black"
    $(printArea).append "<div id='printmap-table-legend'></div>"
    printmapTableLegend = $("#printmap-table-legend")
    $(printmapTableLegend).append "<table class='printmap-table'><tbody class='printmap-legend'></tbody></table>"

    $("#layer-list input:checked").each ->
      layerId = $(@).attr("id")
      if layerId?
        modelId = layerId.split("-")[0]
        checkedItems = $("#"+modelId+"-legend .table .legendItems input:checked")
        checkedItems.each ->
          itemId = $(@).attr("column")
          imgId = $("#"+modelId+"-legend .table .legendItems .legend-image-"+itemId)
#          imgTxt = $("#"+modelId+"-legend .table .legendItems .legend-image-"+itemId)
          tableObj = $(".printmap-legend")
          cloneObj = $(imgId).clone(true,true)
          squareSvgStyles =
            height:'30px'
            width:'30px'

          circleSvgStyles =
            height:'24px'
            width:'24px'

          dStyles =
            d:"M 5 30 q 10 -35 20 -15"

          circleStyles =
            cx:10
            cy:10
            r:6

          $(cloneObj).find('#square').css squareSvgStyles
          $(cloneObj).find('#circle').css circleSvgStyles
          $(cloneObj).find('path').attr dStyles
          $(cloneObj).find('circle').attr circleStyles


          $(tableObj).append "<tr></tr>"
          $(cloneObj).appendTo tableObj

  printMap: () ->
    ele = $("#print-area").html()
    htmlone = '<html><head>
      <link rel="stylesheet" href="vendor/leaflet/leaflet.css">
      <link rel="stylesheet" href="vendor/leaflet-draw/leaflet.draw.css">
      <link rel="stylesheet" href="styles/base.css">
      </head><body><div id="printable">'
    html2 = '</div></body></html>'
    string = htmlone + ele + html2
    w=window.open()
    w.document.write(string)
    app.map.invalidateSize(false)

  resetMap: () ->
    if $("#print-modal").modal "hide"
      $("#print-modal .modal-body").empty()
      $(".modal-body").css
        "max-height": "400px"
      $(".modal").css
        "margin-left": "-280px"
        "top":"10%"

  insertTitle: () ->
    top = $("#print-modal .modal-body #map")
    $(top).before '<input id="title-input" type="text" name="title" value="Type a Title and Press Enter">'
    $('input[name="title"]').change ->
      value = $('input[name="title"]').val()
      $(top).before "<p id='title' style='text-align:center; font-size:20px; font-weight:bold;'></p>"
      $("#title").append value
      $("#title-input").remove()