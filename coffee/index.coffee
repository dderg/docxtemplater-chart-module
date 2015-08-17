SubContent=require('docxtemplater').SubContent

fs=require('fs')

class ChartModule
	constructor:(@options={})->

	handleEvent:(event,eventData)->
		console.log('event: ' + event);
		# if event=='rendering-file'
		# 	@renderingFileName=eventData
		# 	gen=@manager.getInstance('gen')
		# 	@imgManager=new ImgManager(gen.zip,@renderingFileName)
		# 	@imgManager.loadImageRels()
		# if event=='rendered'
		# 	if @qrQueue.length==0 then @finished()
	get:(data)->
		console.log('get data: ' + data);
		if data == 'loopType'
			templaterState=@manager.getInstance('templaterState')
			if templaterState.textInsideTag[0]=='$'
				return 'chart'
		null
	getNextImageName:()->
		name="image_generated_#{@imageNumber}.png"
		@imageNumber++
		name
	replaceBy:(text,outsideElement)->
		xmlTemplater=@manager.getInstance('xmlTemplater')
		templaterState=@manager.getInstance('templaterState')
		subContent=new SubContent(xmlTemplater.content)
			.getInnerTag(templaterState)
			.getOuterXml(outsideElement)
		xmlTemplater.replaceXml(subContent,text)
	convertPixelsToEmus:(pixel)->
		Math.round(pixel * 9525)
	getSizeFromData:(imgData)->
		[150,150]
	getImageFromData:(imgData)->
		fs.readFileSync(imgData)
	replaceTag:->
		console.log('replacing tag');
		# scopeManager=@manager.getInstance('scopeManager')
		# templaterState=@manager.getInstance('templaterState')

		# tag = templaterState.textInsideTag.substr(1)
		# imgData=scopeManager.getValueFromScope(tag)

		# tagXml=@manager.getInstance('xmlTemplater').tagXml
		# startEnd= "<#{tagXml}></#{tagXml}>"
		# if imgData=='undefined' then return @replaceBy(startEnd,tagXml)
		# try
		# 	imgBuffer=@getImageFromData(imgData)
		# catch e
		# 	return @replaceBy(startEnd,tagXml)
		# imageRels=@imgManager.loadImageRels();
		# if imageRels
		# 	rId=imageRels.addImageRels(@getNextImageName(),imgBuffer)

		# 	sizePixel=@getSizeFromData(imgBuffer)
		# 	size=[@convertPixelsToEmus(sizePixel[0]),@convertPixelsToEmus(sizePixel[1])]

		# 	if @options.centered==false
		# 		outsideElement=tagXml
		# 		newText=@getImageXml(rId,size)
		# 	if @options.centered==true
		# 		outsideElement=tagXml.substr(0,1)+':p'
		# 		newText=@getImageXmlCentered(rId,size)

		# 	@replaceBy(newText,outsideElement)
	
	finished:->
	on:(event,data)->
		if event=='error'
			throw data
	handle:(type,data)->
		console.log('type: ' + type);
		console.log('data: ' + data);

	

module.exports = ChartModule
