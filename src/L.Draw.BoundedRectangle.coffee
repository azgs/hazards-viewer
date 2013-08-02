L.Draw.BoundedRectangle = L.Draw.Rectangle.extend
  _onMouseMove: (e) ->
    @_tooltip.updatePosition e.latlng

    if @_isDrawing
      bounds = new L.LatLngBounds @_startLatLng, e.latlng
      dx = Math.abs(bounds.getEast() - bounds.getWest())
      dy = Math.abs(bounds.getNorth() - bounds.getSouth())
      area = dx * dy

      if area > 1
        @options.shapeOptions.color = "red"
        text = "Area too large"
        @_inBounds = false
      else
        @options.shapeOptions.color = "green"
        text = "Select the area you wish to download"
        @_inBounds = true

      @_tooltip.updateContent
        text: text

      @_drawShape e.latlng
      @_shape.setStyle @options.shapeOptions

  _fireCreatedEvent: () ->
    bounds = @_shape.getBounds()

    if @_inBounds
      rectangle = new L.Rectangle bounds, @options.shapeOptions
      L.Draw.SimpleShape.prototype._fireCreatedEvent.call @, rectangle
    else
      pt = @_map.latLngToContainerPoint bounds.getSouthEast()
      alertMsg = "<div class='alert alert-error alert-block fade in' style='position:relative;top:#{pt.y-25}px;left:#{pt.x}px;z-index:900;width:200px;'><button type='button' class='close' data-dismiss='alert'>×</button><strong>The area you drew was too large</strong></div>"
      err = $(alertMsg).appendTo $("#map")

      err.alert().bind "closed", () ->
        $(".alert").remove()

      @_map.once "move", () ->
        $(".alert").remove()