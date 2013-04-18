# Setup a global object to stash our work in
root = @
if not root.app? then app = root.app = {} else app = root.app

class app.SidebarView extends Backbone.View
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
    
    if $(layer).is(":checked")
      app.map.addLayer(item.get("layer"))
    else
      app.map.removeLayer(item.get("layer"))