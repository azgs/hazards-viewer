# Setup a global object to stash our work in
root = @
if not root.app? then app = root.app = {} else app = root.app
if not app.models then models = app.models = {} else models = app.models

class models.LegendItemModel extends Backbone.Model
  defaults:
    caption: "Some Legend Item"
    attribute: "symbol" # Attribute from the dataset that determines this filter
    value: "x" # Value to filter on
    imageTemplateId: "imageTemplate"
    imageInfo: {} # Passed to the template to generate an image for the legend item

  initialize: (options) ->
    @id = options.id or "legendItem-#{Math.floor(Math.random() * 101)}"
    template = $("##{options.imageTemplateId or @defaults.imageTemplateId}")
    imageTemplate = if template.length > 0 then _.template template.html() else _.template "<div></div>"
    @set "image", imageTemplate
      info: options.imageInfo or {}

class models.Legend extends Backbone.Collection
  model: models.LegendItemModel

  initialize: (items, options) ->
    @filterable = if options.filterable? then options.filterable else true
    @heading = options.heading or "Heading"
