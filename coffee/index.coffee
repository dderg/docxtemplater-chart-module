SubContent = require('docxtemplater').SubContent
ChartManager = require('./chartManager')

fs = require('fs')

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
		if (event == 'rendering-file')
			renderingFileName = eventData;
			console.log(renderingFileName)
			gen = @manager.getInstance('gen');
			@chartManager = new ChartManager(gen.zip, renderingFileName)
			@chartManager.loadChartRels();
			
		else if (event == 'rendered')
			@finished()

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
			console.log('handle')
			@replaceTag()
		return null
	
	finished: () ->
		console.log('finished')

	on: (event, data) ->
		if event == 'error'
			throw data

	replaceTag: () ->
		console.log('replacing tag');
		scopeManager = @manager.getInstance('scopeManager')
		templaterState = @manager.getInstance('templaterState')

		tag = templaterState.textInsideTag.substr(1)
		chartData = scopeManager.getValueFromScope(tag)
		console.log('tag: ' + tag)


		imageRels = @chartManager.loadChartRels()
		console.log('imageRels: ' + imageRels)
		
		return unless imageRels
		@chartManager.addChartRels(tag)
		
		# tagXml = @manager.getInstance('xmlTemplater').tagXml



module.exports = ChartModule
