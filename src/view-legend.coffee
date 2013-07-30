# Setup a global object to stash our work in
root = @
if not root.app? then app = root.app = {} else app = root.app
if not app.views? then app.views = views = {} else views = app.views

class views.LegendView extends Backbone.View
  initialize: (options) ->
    @template = _.template $("#legend-template").html()
    @itemTemplate = _.template $("#legendItem-template").html()
    @layerModel = options.layerModel or null

  render: () ->
    # Append the legend container
    @$el.append @template
      model: @collection

    # Setup to append legend item templates
    el = @$el.find ".legendItems"
    itemTemplate = @itemTemplate
    filterable = @collection.filterable

    @collection.forEach (model) ->
      # Append the legend item template
      thisone = $(itemTemplate({model: model, filter: filterable}).replace(/\n|\t|  /g, "")).appendTo el

      # Append the legend image template
      attribute = model.get "attribute"
      thisone.children(".legend-image-"+attribute).append model.get "image"

    return @

  events:
    "click .filter": "applyFilter"

  applyFilter: (e) ->
    # Find which boxes are currently checked
    filterObj = (boxEl) ->
      obj = {}
      obj[$(box).attr("column")] = $(box).attr("columnvalue")
      return obj

    oldLayer = @layerModel.get("layer")
    @layerModel.once "layerLoaded", (newLayer) ->
      if app.map.hasLayer oldLayer
        app.map.removeLayer oldLayer
        newLayer.addTo app.map

    filters = ( filterObj(box) for box in @$el.find(".filter") when $(box).is(":checked") )
    @layerModel.filterLayer filters