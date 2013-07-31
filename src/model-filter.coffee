# Setup a global object to stash our work in
root = @
if not root.app? then app = root.app = {} else app = root.app
if not app.models then models = app.models = {} else models = app.models

class models.Filter extends Backbone.Model
  initialize: (filters) ->
    makeFilter = (rule) ->
      for prop, val of rule
        try
          val = JSON.parse val

        if typeof val is "object"
          return between rule

        if val.indexOf("contains(") is 0
          newRule = (k, v) ->
            o = {}
            o[k] = v
            o

          terms = val.replace("contains(","").replace(")","").split(",")
          return (equalTo(newRule(prop, term)) for term in terms)

        return equalTo rule

    between = (rule) ->
      for prop, val of rule
        val = JSON.parse val
        return new OpenLayers.Filter.Comparison
          type: OpenLayers.Filter.Comparison.BETWEEN
          property: prop
          lowerBoundary: val[0]
          upperBoundary: val[1]

    equalTo = (rule) ->
      for prop, val of rule
        return new OpenLayers.Filter.Comparison
          type: OpenLayers.Filter.Comparison.EQUAL_TO
          property: prop
          value: val

    propFilters = []
    for rule in filters
      filter = makeFilter rule
      if _.isArray filter
        propFilters = _.union propFilters, filter
      else
        propFilters.push filter

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
