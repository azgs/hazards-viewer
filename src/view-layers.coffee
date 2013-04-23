# Setup a global object to stash our work in
root = @
if not root.app? then app = root.app = {} else app = root.app

class app.SidebarView extends Backbone.View
  events: ->
    "click input[type=checkbox]": "toggleLayer"

  initialize: ->
    @template=_.template $("#model-template").html()

  render: ->
    el=@$el
    template = @template
    _.each @collection.models, (model) ->
      el.append template
        model:model
    return @

  toggleLayer:(e) ->
    element = $(e.currentTarget).attr "id"
    item = @collection.get element
    id = item.get "id"
    layer = "##{id.toString()}"

    if $(layer).is(":checked")
      app.map.addLayer(item.get("defaultLayer"))
    else
      app.map.removeLayer(item.get("defaultLayer"))

class app.baseMapView extends Backbone.View
  events: ->
    "click": "switchBaseMap"
    
  initialize: ->
    @template=_.template $("#basemap-template").html()
    _.each @collection.models, (model) ->
      if model.get "active"
        app.map.addLayer(model.get("baseLayer"))

  render: ->
    el=@$el
    template = @template
    _.each @collection.models, (model) ->
      el.append template
        model:model
    return @

  switchBaseMap:(e) ->
    _.each @collection.models, (model) ->
      app.map.removeLayer(model.get("baseLayer"))

    element = $(e.target).attr "id"
    item = @collection.get element
    app.map.addLayer(item.get("baseLayer"))
