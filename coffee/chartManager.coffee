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
		console.log('loadChartRels')
		###*
		 * load file, save path
		 * @param  {String} filePath path to current file
		 * @return {Object}          file
		###
		loadFile = (filePath) =>
			@filePath = filePath
			console.log('loading file: ' + @filePath)
			return @zip.files[@filePath]

		file = loadFile("word/_rels/#{@endFileName}.xml.rels") || loadFile("word/_rels/document.xml.rels") #duct tape hack, doesn't work otherwise
		return if file == undefined
		content = DocUtils.decode_utf8(file.asText())
		@xmlDoc = DocUtils.Str2xml(content)
		RidArray = ((parseInt tag.getAttribute("Id").substr(3)) for tag in @xmlDoc.getElementsByTagName('Relationship')) #Get all Rids
		@maxRid = DocUtils.maxArray(RidArray)
		console.log @maxRid
		# console.log @xmlDoc
		@chartRels = []
		@relsLoaded = true
		return this


	addChartRels: (chartName) ->
		###*
		 * add relationship tag to relationships
		###
		addTag = () =>
			relationships = @xmlDoc.getElementsByTagName("Relationships")[0]
			newTag = @xmlDoc.createElement('Relationship')
			newTag.namespaceURI = null
			newTag.setAttribute('Id', "rId#{@maxRid}")
			newTag.setAttribute('Type', 'http://schemas.openxmlformats.org/officeDocument/2006/relationships/chart')
			newTag.setAttribute('Target', "charts/#{chartName}")
			relationships.appendChild(newTag)

		console.log('addChartRels')
		console.log('name: ' + chartName)
		return unless @relsLoaded
		@maxRid++

		addTag();


		@zip.file(@filePath, DocUtils.encode_utf8(DocUtils.xml2Str(@xmlDoc)), {})
		return @maxRid

