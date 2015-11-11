DOMParser = require('xmldom').DOMParser
XMLSerializer= require('xmldom').XMLSerializer

DocUtils = {}

DocUtils.xml2Str = (xmlNode) ->
	a = new XMLSerializer()
	a.serializeToString(xmlNode)

DocUtils.Str2xml= (str,errorHandler) ->
	parser = new DOMParser({errorHandler})
	xmlDoc=parser.parseFromString(str,"text/xml")

DocUtils.maxArray = (a) -> Math.max.apply(null, a)

DocUtils.decodeUtf8 = (s) ->
	try
		if s==undefined then return undefined
		return decodeURIComponent(escape(DocUtils.convertSpaces(s))) #replace Ascii 160 space by the normal space, Ascii 32
	catch e
		console.error s
		console.error 'could not decode'
		throw new Error('end')

DocUtils.encodeUtf8 = (s)->
	unescape(encodeURIComponent(s))

DocUtils.convertSpaces = (s) ->
	s.replace(new RegExp(String.fromCharCode(160),"g")," ")

DocUtils.pregMatchAll = (regex, content) ->
	###regex is a string, content is the content. It returns an array of all matches with their offset, for example:
	regex=la
	content=lolalolilala
	returns: [{0:'la',offset:2},{0:'la',offset:8},{0:'la',offset:10}]
	###
	regex= (new RegExp(regex,'g')) unless (typeof regex=='object')
	matchArray= []
	replacer = (match,pn ..., offset, string)->
		pn.unshift match #add match so that pn[0] = whole match, pn[1]= first parenthesis,...
		pn.offset= offset
		matchArray.push pn
	content.replace regex,replacer
	matchArray

module.exports=DocUtils
