class app.singleLiView extends Backbone.View
  events: ->
    "click input[type=checkbox]": "callback"
  initialize: ->
    @template=_.template $("#model-template").html()
  render: ->
    el=@$el
    template=@template
    _.each @collection.models, (model) ->
      el.append template
        model:model
  callback:(e) ->
    element=$(e.currentTarget).attr "id"
    item=@collection.get element
    id=item.get "id"
    layer="#"+id.toString()
    
    if $(layer).is(":checked") then root.map.addLayer(item.get("layer")) else root.map.removeLayer(item.get("layer"))

new app.singleLiView
  el:$("#layer-list").first()
  collection:app.layerCollection
.render()

















