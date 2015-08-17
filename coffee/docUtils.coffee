DOMParser = require('xmldom').DOMParser
XMLSerializer= require('xmldom').XMLSerializer

DocUtils= require('docxtemplater').DocUtils

DocUtils.xml2Str = (xmlNode) ->
	a= new XMLSerializer()
	a.serializeToString(xmlNode)

DocUtils.Str2xml= (str,errorHandler) ->
	parser=new DOMParser({errorHandler})
	xmlDoc=parser.parseFromString(str,"text/xml")

DocUtils.maxArray = (a) -> Math.max.apply(null, a)

module.exports=DocUtils
