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

	doPopover = () ->
		@steps = [
				ele: $ "#nav #menu .dropdown"
				content: "this is a test"
				place: "right"
			,
				ele: $ "#nav #menu"
				content: "another test"
				place: "bottom"
			,
				ele: $ "#nav #geocoder"
				content: "one more test"
				place: "left"
		]

		@step = 0

		@steps.forEach (step, index) ->
			content = "<p>" + step.content + "   " + index + "</p>"
			cancelText = if index != 2 then "Cancel Tutorial" else "Finish Tutorial"
			content += "<div class='btn-group pull-right'>"
			content += "<button class='btn tutorial-cancel' href='#'>" + cancelText + "</button>"
			if index != 2 then content += "<button class='btn btn-primary tutorial-next' href='#'> Next Step > </button>"
			content += "</div>"

			step.ele.popover
				title: "my title"
				html: true
				content: content
				trigger: "manual"
				placement: step.place

			if index != 0 then step.ele.popover('hide') else step.ele.popover('show')

	doHelp: () ->
		@$el.modal "hide"

		doPopover()