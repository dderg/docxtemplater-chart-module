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
	 * @param  {[type]} @options params for the module
	 * @return {[type]}          [description]
	###
	constructor: (@options = {}) ->

	handleEvent: (event, eventData) ->
		console.log('handleEvent event: ' + event);
		if (event == 'rendering-file')
			renderingFileName = eventData;
			# console.log(renderingFileName)
			gen = @manager.getInstance('gen');
			@chartManager = new ChartManager(gen.zip, renderingFileName)
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
		console.log('finished')

	on: (event, data) ->
		if event == 'error'
			throw data

	replaceBy: (text,outsideElement) ->
		xmlTemplater = @manager.getInstance('xmlTemplater')
		templaterState = @manager.getInstance('templaterState')
		subContent = new SubContent(xmlTemplater.content)
			.getInnerTag(templaterState)
			.getOuterXml(outsideElement)
		xmlTemplater.replaceXml(subContent,text)


	replaceTag: () ->
		# console.log('replacing tag');
		scopeManager = @manager.getInstance('scopeManager')
		templaterState = @manager.getInstance('templaterState')
		gen = @manager.getInstance('gen');

		tag = templaterState.textInsideTag.substr(1)
		chartData = scopeManager.getValueFromScope(tag)
		# console.log('tag: ' + tag)\
		filename = tag


		imageRels = @chartManager.loadChartRels()
		# console.log('imageRels: ' + imageRels)

		return unless imageRels
		chartId = @chartManager.addChartRels(filename)

		chart = new ChartMaker(gen.zip)
		chart.makeChartFile(chartData)
		chart.writeFile(filename)
		
		tagXml = @manager.getInstance('xmlTemplater').tagXml

		@replaceBy(@getChartXml(chartId), tagXml)

	getChartXml: (chartID) ->
		return """
			<w:drawing>
				<wp:inline distB="0" distL="0" distR="0" distT="0">
					<wp:extent cx="5486400" cy="3200400"/>
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
