Chart module for docxtemplater.

this module is not ready yet, contact me if you want to help me with this

# Installation:

You will need docxtemplater v1: `npm install docxtemplater`

<!-- install this module: `npm install docxtemplater-image-module` -->

# Usage

Your docx should contain the text: `{$chart}`

    ChartModule=require(‘docxtemplater-chart-module’)

    chartModule=new ChartModule({centered:false})

    docx=new DocxGen()
        .attachModule(chartModule)
        .load(content)
        .setData({chart:'here should go data'})
        .render()

    buffer= docx
            .getZip()
            .generate({type:"nodebuffer"})

    fs.writeFile("test.docx",buffer);


# Building

 You can build the coffee into js by running `gulp` (this will watch the directory for changes)

# Testing

You can test that everything works fine using the command `mocha`. This will also create 3 docx files under the root directory that you can open to check if the docx are correct
