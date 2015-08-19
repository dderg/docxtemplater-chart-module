DocUtils = require('./docUtils')

module.exports = class ChartManager
	constructor: (@zip, @fileName) ->
		@endFileName = @fileName.replace(/^.*?([a-z0-9]+)\.xml$/, "$1")
		@relsLoaded = false
	###*
	 * load relationships
	 * @return {ChartManager} for chaining
	###
	loadChartRels: () ->
		# console.log('loadChartRels')
		###*
		 * load file, save path
		 * @param  {String} filePath path to current file
		 * @return {Object}          file
		###
		loadFile = (filePath) =>
			@filePath = filePath
			# console.log('loading file: ' + @filePath)
			return @zip.files[@filePath]

		file = loadFile("word/_rels/#{@endFileName}.xml.rels") || loadFile("word/_rels/document.xml.rels") #duct tape hack, doesn't work otherwise
		return if file == undefined
		content = DocUtils.decode_utf8(file.asText())
		@xmlDoc = DocUtils.Str2xml(content)
		RidArray = ((parseInt tag.getAttribute("Id").substr(3)) for tag in @xmlDoc.getElementsByTagName('Relationship')) #Get all Rids
		@maxRid = DocUtils.maxArray(RidArray)
		# console.log @xmlDoc
		@chartRels = []
		@relsLoaded = true
		return this


	addChartRels: (chartName) ->
		# console.log('addChartRels')
		# console.log('name: ' + chartName)
		return unless @relsLoaded
		@maxRid++
		@_addChartRelationship(@maxRid, chartName);
		@_addChartContentType(chartName);

		@zip.file(@filePath, DocUtils.encode_utf8(DocUtils.xml2Str(@xmlDoc)), {})
		return @maxRid

	###*
	 * add relationship tag to relationships
	 * @param {Number} id   relationship ID
	 * @param {String} name target file name
	###
	_addChartRelationship: (id, name) ->
		relationships = @xmlDoc.getElementsByTagName("Relationships")[0]
		newTag = @xmlDoc.createElement('Relationship')
		newTag.namespaceURI = null
		newTag.setAttribute('Id', "rId#{id}")
		newTag.setAttribute('Type', 'http://schemas.openxmlformats.org/officeDocument/2006/relationships/chart')
		newTag.setAttribute('Target', "charts/#{name}.xml")
		relationships.appendChild(newTag)

	###*
	 * add override to [Content_Types].xml
	 * @param {String} name filename
	###
	_addChartContentType: (name) ->
		path = '[Content_Types].xml'
		file = @zip.files[path]
		content = DocUtils.decode_utf8(file.asText())
		xmlDoc = DocUtils.Str2xml(content)
		types = xmlDoc.getElementsByTagName("Types")[0]
		newTag = xmlDoc.createElement('Override')
		newTag.namespaceURI = 'http://schemas.openxmlformats.org/package/2006/content-types'
		newTag.setAttribute('ContentType', 'application/vnd.openxmlformats-officedocument.drawingml.chart+xml')
		newTag.setAttribute('PartName', "/word/charts/#{name}.xml")
		types.appendChild(newTag)
		@zip.file(path, DocUtils.encode_utf8(DocUtils.xml2Str(xmlDoc)), {})
