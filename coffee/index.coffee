SubContent = require('docxtemplater').SubContent
ChartManager = require('./chartManager')
ChartMaker = require('./chartMaker')

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
	 * @param  {Object} @options params for the module
	###
	constructor: (@options = {}) ->

	handleEvent: (event, eventData) ->
		if (event == 'rendering-file')
			@renderingFileName = eventData;
			# console.log(renderingFileName)
			gen = @manager.getInstance('gen');
			@chartManager = new ChartManager(gen.zip, @renderingFileName)
			@chartManager.loadChartRels();
			
		else if (event == 'rendered')
			@finished()

	get: (data) ->
		# console.log('get data: ' + data);
		if data == 'loopType'
			templaterState = @manager.getInstance('templaterState')
			# console.log(templaterState.textInsideTag)
			if templaterState.textInsideTag[0] == '$'
				return @name
		return null
	
	handle: (type, data) ->
		if (type == 'replaceTag' and data == @name)
			# console.log('handle')
			@replaceTag()
		return null
	
	finished: () ->

	on: (event, data) ->
		if event == 'error'
			throw data

	replaceBy: (text, outsideElement) ->
		xmlTemplater = @manager.getInstance('xmlTemplater')
		templaterState = @manager.getInstance('templaterState')
		subContent = new SubContent(xmlTemplater.content)
			.getInnerTag(templaterState)
			.getOuterXml(outsideElement)
		xmlTemplater.replaceXml(subContent,text)

	convertPixelsToEmus: (pixel) ->
		Math.round(pixel * 9525)

	extendDefaults: (options) ->
		defaultOptions = {
			width: 5486400 / 9525,
			height: 3200400 / 9525
		}
		result = {};
		for attrname of defaultOptions
			result[attrname] = defaultOptions[attrname]
		for attrname of options
			result[attrname] = options[attrname]
		return result;


	replaceTag: () ->
		scopeManager = @manager.getInstance('scopeManager')
		templaterState = @manager.getInstance('templaterState')
		gen = @manager.getInstance('gen');

		tag = templaterState.textInsideTag.substr(1) # tag to be replaced
		chartData = scopeManager.getValueFromScope(tag) # data to build chart from
		filename = tag


		imageRels = @chartManager.loadChartRels()

		return unless imageRels # break if no Relationships loaded
		chartId = @chartManager.addChartRels(filename)

		chart = new ChartMaker(gen.zip)
		chart.makeChartFile(chartData.lines)
		chart.writeFile(filename)
		
		options = @extendDefaults(chartData.options)
		
		tagXml = @manager.getInstance('xmlTemplater').tagXml

		newText = @getChartXml({
			chartID: chartId,
			width: @convertPixelsToEmus(options.width),
			height: @convertPixelsToEmus(options.height)
		})
		@replaceBy(newText, tagXml)

	getChartXml: ({chartID, width, height}) ->
		return """
			<w:drawing>
				<wp:inline distB="0" distL="0" distR="0" distT="0">
					<wp:extent cx="#{width}" cy="#{height}"/>
					<wp:effectExtent b="0" l="19050" r="19050" t="0"/>
					<wp:docPr id="1" name="Диаграмма 1"/>
					<wp:cNvGraphicFramePr/>
					<a:graphic xmlns:a="http://schemas.openxmlformats.org/drawingml/2006/main">
						<a:graphicData uri="http://schemas.openxmlformats.org/drawingml/2006/chart">
							<c:chart r:id="rId#{chartID}" xmlns:c="http://schemas.openxmlformats.org/drawingml/2006/chart" xmlns:r="http://schemas.openxmlformats.org/officeDocument/2006/relationships"/>
						</a:graphicData>
					</a:graphic>
				</wp:inline>
			</w:drawing>
		"""



module.exports = ChartModule
