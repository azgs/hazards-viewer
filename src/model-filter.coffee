# Setup a global object to stash our work in
root = @
if not root.app? then app = root.app = {} else app = root.app
if not app.models then models = app.models = {} else models = app.models


class models.Filter extends Backbone.Model
  initialize: (filters) ->
    equals = (rule) ->
      for prop, val of rule
        return new OpenLayers.Filter.Comparison
          type: OpenLayers.Filter.Comparison.EQUAL_TO
          property: prop
          value: val

    propFilters = ( equals(rule) for rule in filters or [] )

    @filterObj = new OpenLayers.Filter.Logical
      type: OpenLayers.Filter.Logical.OR
      filters: propFilters

  asXml: () ->
    xml = new OpenLayers.Format.XML()
    writer = new OpenLayers.Format.Filter
      version: "1.1.0"
    xml.write writer.write @filterObj

  urlEncoded: () ->
    encodeURI @asXml()