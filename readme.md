Chart module for docxtemplater.

this module is not ready yet, contact me on gnomdan@yandex.ru or @prog666 in telegram if you want to help me with this

# Installation:

You will need docxtemplater v1: `npm install docxtemplater`

install this modile: `npm install docxtemplater-chart-module`

# Usage

Your docx should contain the text: `{$chart}`

    ChartModule=require(‘docxtemplater-chart-module’)

    chartModule=new ChartModule({centered:false})

    docx=new DocxGen()
        .attachModule(chartModule)
        .load(content)
        .setData({
          chart: {
            lines: [
              {
                name: 'Ряд 1',
                data: [
                  {
                    x: 'Категория 1',
                    y: '4.3'
                  },
                  {
                    x: 'Категория 2',
                    y: '2.5'
                  },
                  {
                    x: 'Категория 3',
                    y: '3.5'
                  },
                  {
                    x: 'Категория 4',
                    y: '4.5'
                  }
                ]
              },
              {
                name: 'Ряд 2',
                data: [
                  {
                    x: 'Категория 1',
                    y: '2.4'
                  },
                  {
                    x: 'Категория 2',
                    y: '4.4000000000000004'
                  },
                  {
                    x: 'Категория 3',
                    y: '1.8'
                  },
                  {
                    x: 'Категория 4',
                    y: '2.8'
                  }
                ]
              },
              {
                name: 'Ряд 3',
                data: [
                  {
                    x: 'Категория 1',
                    y: '2'
                  },
                  {
                    x: 'Категория 2',
                    y: '2'
                  },
                  {
                    x: 'Категория 3',
                    y: '3'
                  },
                  {
                    x: 'Категория 4',
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
