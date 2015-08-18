SubContent=require('docxtemplater').SubContent

fs=require('fs')

class ChartModule
	###*
	 * self name for self-identification, variable for fast changing;
	 * @type {String}
	###
	name: 'chart'

	###*
	 * initialize options with empty object if not recived
	 * @manager = ModuleManager instance
	 * @param  {[type]} @options params for the module
	 * @return {[type]}          [description]
	###
	constructor: (@options = {}) ->

	handleEvent: (event, eventData) ->
		console.log('handleEvent event: ' + event);
		console.log('handleEvent eventData: ' + eventData);
		if (event == 'rendering-file')
			@createChart(eventData)

	get: (data) ->
		console.log('get data: ' + data);
		if data == 'loopType'
			templaterState = @manager.getInstance('templaterState')
			console.log(templaterState.textInsideTag)
			if templaterState.textInsideTag[0] == '$'
				return @name
		return null
	
	handle: (type, data) ->
		if (type == 'replaceTag' and data == @name)
			@replaceTag()
		return null
	
	finished: () ->

	on: (event, data) ->
		console.log('on event: ' + event);
		console.log('on data: ' + data);
		if event == 'error'
			throw data

	replaceTag: () ->
		console.log('replacing tag');

	createChart: (eventData) ->
		renderingFileName = eventData;
		gen = @manager.getInstance('gen');
		console.log(gen.zip);
	

module.exports = ChartModule
