# Setup a global object to stash our work in
root = @
if not root.app? then app = root.app = {} else app = root.app
if not app.views? then app.views = views = {} else views = app.views

class views.NavToolView extends Backbone.View
  #events:
    #"click a": "launchNavTool"

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

  launchNavTool: (e) ->
    buttonId = $(e.currentTarget).attr "id"
    modelId = buttonId.split("-")[0]

    item = @collection.get element
    target = item.get "datatarget"
    $(target).modal
      show:true