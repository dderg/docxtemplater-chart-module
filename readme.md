Chart module for docxtemplater.

this module has only simple usage yet, contact me on gnomdan@yandex.ru or @prog666 in telegram if you want to help me with this

[![Join the chat at https://gitter.im/prog666/docxtemplater-chart-module](https://badges.gitter.im/Join%20Chat.svg)](https://gitter.im/prog666/docxtemplater-chart-module?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)

[![Build Status](https://travis-ci.org/prog666/docxtemplater-chart-module.svg?branch=master)](https://travis-ci.org/prog666/docxtemplater-chart-module)

# Installation:

You will need docxtemplater v1: `npm install docxtemplater`

install this modile: `npm install docxtemplater-chart-module`

# Usage

Your docx should contain the text: `{$chart}`

    ChartModule = require(‘docxtemplater-chart-module’)

    chartModule = new ChartModule()

    docx = new DocxGen()
        .attachModule(chartModule)
        .load(content)
        .setData({
          chart: {
            lines: [
              {
                name: 'line 1',
                data: [
                  {
                    x: 'day 1',
                    y: '4.3'
                  },
                  {
                    x: 'day 2',
                    y: '2.5'
                  },
                  {
                    x: 'day 3',
                    y: '3.5'
                  },
                  {
                    x: 'day 4',
                    y: '4.5'
                  }
                ]
              },
              {
                name: 'line 2',
                data: [
                  {
                    x: 'day 1',
                    y: '2.4'
                  },
                  {
                    x: 'day 2',
                    y: '4.4000000000000004'
                  },
                  {
                    x: 'day 3',
                    y: '1.8'
                  },
                  {
                    x: 'day 4',
                    y: '2.8'
                  }
                ]
              },
              {
                name: 'line 3',
                data: [
                  {
                    x: 'day 1',
                    y: '2'
                  },
                  {
                    x: 'day 2',
                    y: '2'
                  },
                  {
                    x: 'day 3',
                    y: '3'
                  },
                  {
                    x: 'day 4',
                    y: '5'
                  }
                ]
              }
            ]
          }
        })
        .render()

    buffer= docx
            .getZip()
            .generate({type:"nodebuffer"})

    fs.writeFile("test.docx",buffer);


# Building

 You can build the coffee into js by running `gulp` (this will watch the directory for changes)

# Testing

You can test that everything works fine using the command `mocha`. This will also create 3 docx files under the root directory that you can open to check if the docx are correct
