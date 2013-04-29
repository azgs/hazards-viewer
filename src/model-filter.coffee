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

        return new OpenLayers.Filter.Comparison
          type: OpenLayers.Filter.Comparison.EQUAL_TO
          property: prop
          value: val

    between = (rule) ->
      for prop, val of rule
        val = JSON.parse val
        return new OpenLayers.Filter.Comparison
          type: OpenLayers.Filter.Comparison.BETWEEN
          property: prop
          lowerBoundary: val[0]
          upperBoundary: val[1]

    propFilters = ( makeFilter(rule) for rule in filters or [] )

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

models.filters = {}
class models.filters.BaseFilter extends Backbone.Model
  filterObj: null

  initialize: (params, options) ->
    @set "version", options.version or "1.1.0"

  asXml: () ->
    xml = new OpenLayers.Format.XML()
    writer = new OpenLayers.Format.Filter
      version: @get "version"
    xml.write writer.write @filterObj

  urlEncoded: () ->
    encodeURI @asXml()

class models.filters.PropertyFilter extends models.filters.BaseFilter
  initialize: (parameters) ->
    # Parameters should be array [ propertyName, value ]
    @filterObj = new OpenLayers.Filter.Comparison
      type: OpenLayers.Filter.Comparison.EQUAL_TO
      property: parameters[0]
      value: parameters[1]

class models.filters.RangeFilter extends models.filters.BaseFilter
  initialize: (parameters) ->
    # parameters should be arra [ propertyName, [ lowerBound, upperBound ] ]
    @filterObj = new OpenLayers.Filter.Comparison
      type: OpenLayers.Filter.Comparison.BETWEEN
      property: parameters[0]
      lowerBoundary: parameters[1][0]
      upperBoundary: parameters[1][1]

class models.filters.BBoxFilter extends models.filters.BaseFilter
  initialize: (parameters) ->
    # parameters should be array [ propertyName, [left, bottom, right, top] ]
    @filterObj = new OpenLayers.Filter.Spatial
      type: OpenLayers.Filter.Spatial.BBOX
      property: parameters[0]
      value: new OpenLayers.Bounds parameters[1][0], parameters[1][1], parameters[1][2], parameters[1][3]

class models.filters.AndFilter extends models.filters.BaseFilter
  initialize: (filters) ->
    @filterObj = new OpenLayers.Filter.Logical
      type: OpenLayers.Filter.Logical.AND
      filters: ( f.filterObj for f in filters )

class models.filters.OrFilter extends models.filters.BaseFilter
  initialize: (filters) ->
    @filterObj = new OpenLayers.Filter.Logical
      type: OpenLayers.Filter.Logical.OR
      filters: ( f.filterObj for f in filters )

