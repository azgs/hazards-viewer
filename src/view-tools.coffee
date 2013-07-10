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
  template: _.template $("#print-tool").html()

  initialize: ->

  render: ->
    that=@
    domEls = [
      that.printBody = @$el.find ".modal-body"
      printFooter = @$el.find ".modal-footer"
    ]
    domEls.forEach (el) ->
      el.empty()
    that.printBody.append @template
    @collection.forEach (model) ->
      if model.get "print"
        printBody.append @template
          model: model

    newButtons = [
      resetBtn = '<button id="reset-btn" class="btn" style="float:left;">Reset</button>'
      closeBtn = '<button id="close-btn" data-dismiss="modal" aria-hidden="true" class="btn">Close</button>'
      previewBtn = '<button id="preview-btn" class="btn btn-primary">Preview</button>'
    ]
    newButtons.forEach (button) ->
      $("#print-modal .modal-footer").append(button)

  events: ->
    "click #preview-btn":"previewMap"
    "click #print-btn":"printMap"
    "click #reset-btn":"resetMap"

  previewMap: () ->
    $("#preview-btn").replaceWith "<button id='print-btn' class='btn btn-primary'>Print</button>"
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
    $(printmapTableLegend).append "Legend"
    $(printmapTableLegend).append "<table class='printmap-table'><tbody class='printmap-legend'></tbody></table>"

    $("#layer-list input:checked").each ->
      layerId = $(@).attr("id")
      console.log layerId
      if layerId?
        modelId = layerId.split("-")[0]
        checkedItems = $("#"+modelId+"-legend .table .legendItems input:checked")
        checkedItems.each ->
          itemId = $(@).attr("column")
          console.log itemId
          imgId = $("#"+modelId+"-legend .table .legendItems .legend-item-"+itemId)
          console.log imgId
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

          legendTextStyle =
            "font-size":"10px"

          $(cloneObj).find('#square').css squareSvgStyles
          $(cloneObj).find('#circle').css circleSvgStyles
          $(cloneObj).find('path').attr dStyles
          $(cloneObj).find('circle').attr circleStyles

          $(cloneObj).find(":checkbox").remove ":checkbox"
          $(cloneObj).find(".legend-text").css legendTextStyle
          $(cloneObj).appendTo tableObj

    top = $("#print-modal .modal-body #map")
    $(top).before '<input id="title-input" type="text" name="title" value="Type a Title and Press Enter">'
    $('input[name="title"]').change ->
      value = $('input[name="title"]').val()
      $(top).before "<p id='title' style='text-align:left; font-size:20px; font-weight:bold;'></p>"
      $("#title").append value
      $("#title-input").remove()


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