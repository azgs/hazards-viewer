# Setup a global object to stash our work in
root = @
if not root.app? then app = root.app = {} else app = root.app
if not app.views? then app.views = views = {} else views = app.views

class views.HelpView extends Backbone.View
	initialize: (options) ->
		@element = options.element

	render: ->
		footer = @$el.find ".modal-footer"
		footer.empty()

		newBtns = [
			close = '<button id="closeHelp-btn" data-dismiss="modal" aria-hidden="true" class="btn">Close</button>'
			help = '<button id="mainHelp-btn" class="btn btn-primary">Help!</button>'
		]

		newBtns.forEach (button) ->
			footer.append button

	events: ->
		"click #mainHelp-btn": "doHelp"

	doPopover = ->
		initialize: (collection) ->
			@collection = collection
			@step = 0
			@collection.forEach (model, index) ->
				content = "<p>" + model.get("description") + "</p>"
				cancelText = if index != 4 then "Cancel Tutorial" else "Finish Tutorial"
				content += "<div class='btn-group'>"
				if index != 4
					content += "<button class='btn tutorial-cancel' href='#'>" + cancelText + "</button>" 
				else 
					content += "<button class='btn tutorial-finish' href='#'>" + cancelText
				if index != 4 then content += "<button class='btn btn-primary tutorial-next' href='#'> Next Step > </button>"
				content += "</div>"

				@ele = model.get "ele"
				@ele.popover
					title: model.get "head"
					html: true
					content: content
					trigger: "manual"
					placement: model.get "placement"

		cancel: ->
			@collection.models[@step - 1].attributes.ele.popover "hide" if @step != 0
			@isCanceled = true

		next: ->
			next = @next
			cancel = @cancel
			self = this
			@collection.models[@step - 1].attributes.ele.popover "hide"  if @step != 0
			@step = (if @step + 1 > 5 then 0 else @step + 1)
			if @step != 0
				@collection.models[@step - 1].attributes.ele.popover "show"
				@action = @collection.models[@step - 1].attributes.action
				if @action then @action()

				$(".tutorial-finish").one "click", (e) ->
		        	cancel.call self

				$(".tutorial-cancel").one "click", (e) ->
		        	cancel.call self

		    	$(".tutorial-next").one "click", (e) ->
		    		next.call self
			else
		    	@cancel()

	doHelp: () ->
		col = @collection

		runPopover = () ->
			doPop = doPopover()
			doPop.initialize(col)
			doPop.next()

		@$el.on 'hidden', runPopover
			
		@$el.modal "hide"