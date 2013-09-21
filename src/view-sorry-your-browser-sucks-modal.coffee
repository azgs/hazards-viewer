root = @
if not root.app? then app = root.app = {} else app = root.app
if not app.views? then app.views = views = {} else views = app.views

class app.views.BadModalView extends Backbone.View
  initialize: (options) ->
    @template = _.template $("#your-browser-sucks-modal").html()

  render: () ->
    if L.Browser.ielt9 or not L.Browser.svg
      @$el.append @template()
      @$el.find("#bad-browser-modal").modal('show')

    return @


app.views.badModalView = (options) ->
  new app.views.BadModalView options
