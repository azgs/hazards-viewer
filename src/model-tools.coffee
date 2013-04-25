# Setup a global object to stash our work in
root = @
if not root.app? then app = root.app = {} else app = root.app
if not app.models? then models = app.models = {} else models = app.models

class app.models.NavToolModel extends Backbone.Model
  defaults:
    toolName: "Some Tool"
    modalName: "Do Something"
    modalBody: "Not Implemented Yet"

  initialize: (options) ->
    @id = options.id or "navTool-#{Math.floor(Math.random() * 101)}"

class app.models.NavToolCollection extends Backbone.Collection
  model: app.models.navToolModel