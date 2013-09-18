# Setup a global object to stash our work in
root = @
if not root.app? then app = root.app = {} else app = root.app
if not app.models then models = app.models = {} else models = app.models

class app.models.HelpModel extends Backbone.Model
	defaults:
		id: "some ID"
		ele: "some element"
		head: "some head"
		description: "some description"

class app.models.HelpCollection extends Backbone.Collection
	model: app.models.HelpModel