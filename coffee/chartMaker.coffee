DocUtils = require('./docUtils')
module.exports = class ChartMaker
	getTemplateTop: () ->
		return """
			<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
			<c:chartSpace xmlns:a="http://schemas.openxmlformats.org/drawingml/2006/main" xmlns:c="http://schemas.openxmlformats.org/drawingml/2006/chart" xmlns:r="http://schemas.openxmlformats.org/officeDocument/2006/relationships">
				<c:lang val="ru-RU"/>
				<c:chart>
					<c:plotArea>
						<c:layout/>
						<c:lineChart>
							<c:grouping val="standard"/>
		"""
	getLineTemplate: (line, i) ->
		result = """
			<c:ser>
				<c:idx val="#{i}"/>
				<c:order val="#{i}"/>
				<c:tx>
					<c:strRef>
						<c:strCache>
							<c:ptCount val="1"/>
							<c:pt idx="0">
								<c:v>#{line.name}</c:v>
							</c:pt>
						</c:strCache>
					</c:strRef>
				</c:tx>
				<c:marker>
					<c:symbol val="none"/>
				</c:marker>
				<c:cat>
					<c:strRef>
						<c:strCache>
							<c:ptCount val="#{line.data.length}"/>
		"""
		for elem, i in line.data
			result += """
				<c:pt idx="#{i}">
					<c:v>#{elem.x}</c:v>
				</c:pt>
			"""
		result += """
						</c:strCache>
					</c:strRef>
				</c:cat>
				<c:val>
					<c:numRef>
						<c:numCache>
							<c:formatCode>General</c:formatCode>
							<c:ptCount val="#{line.data.length}"/>
		"""
		for elem, i in line.data
			result += """
				<c:pt idx="#{i}">
					<c:v>#{elem.y}</c:v>
				</c:pt>
			"""
		result += """
						</c:numCache>
					</c:numRef>
				</c:val>
			</c:ser>
		"""
		return result
	getTemplateBottom: () ->
		return """
							<c:marker val="1"/>
							<c:axId val="142309248"/>
							<c:axId val="142310784"/>
						</c:lineChart>
						<c:catAx>
							<c:axId val="142309248"/>
							<c:scaling>
								<c:orientation val="#{@options.orientationY}"/>
							</c:scaling>
							<c:axPos val="b"/>
							<c:tickLblPos val="nextTo"/>
							<c:crossAx val="142310784"/>
							<c:crosses val="autoZero"/>
							<c:auto val="1"/>
							<c:lblAlgn val="ctr"/>
							<c:lblOffset val="100"/>
						</c:catAx>
						<c:valAx>
							<c:axId val="142310784"/>
							<c:scaling>
								<c:orientation val="#{@options.orientationX}"/>
							</c:scaling>
							<c:axPos val="l"/>
							<c:majorGridlines/>
							<c:numFmt formatCode="General" sourceLinked="1"/>
							<c:tickLblPos val="nextTo"/>
							<c:crossAx val="142309248"/>
							<c:crosses val="autoZero"/>
							<c:crossBetween val="between"/>
						</c:valAx>
					</c:plotArea>
					<c:legend>
						<c:legendPos val="#{@options.legendPosition}"/>
						<c:layout/>
					</c:legend>
					<c:plotVisOnly val="1"/>
				</c:chart>
			</c:chartSpace>
		"""
	constructor: (@zip, @options) ->
			

	makeChartFile: (lines) ->
		result = @getTemplateTop()
		for line, i in lines
			result += @getLineTemplate(line, i)
		result += @getTemplateBottom()
		@chartContent = result
		return @chartContent

	writeFile: (path) ->
		@zip.file("word/charts/#{path}.xml", @chartContent, {})
		return