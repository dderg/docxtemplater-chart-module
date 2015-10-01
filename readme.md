Chart module for docxtemplater.

this module has only simple usage yet, contact me on gnomdan@yandex.ru or @prog666 in telegram if you want to help me with this

[![Join the chat at https://gitter.im/prog666/docxtemplater-chart-module](https://badges.gitter.im/Join%20Chat.svg)](https://gitter.im/prog666/docxtemplater-chart-module?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)

[![Build Status](https://travis-ci.org/prog666/docxtemplater-chart-module.svg?branch=master)](https://travis-ci.org/prog666/docxtemplater-chart-module)
[![Download count](https://img.shields.io/npm/dm/docxtemplater-chart-module.svg?style=flat)](https://www.npmjs.org/package/docxtemplater-chart-module)
[![Current tag](https://img.shields.io/npm/v/docxtemplater-chart-module.svg?style=flat)](https://www.npmjs.org/package/docxtemplater-chart-module)
[![Issues closed](http://issuestats.com/github/prog666/docxtemplater-chart-module/badge/issue?style=flat)](http://issuestats.com/github/prog666/docxtemplater-chart-module)

# Installation:

You will need docxtemplater v1: `npm install docxtemplater`

install this modile: `npm install docxtemplater-chart-module`

# Usage

Your docx should contain the text: `{$chart}`
```javascript
var fs = require('fs');
var ChartModule = require(‘docxtemplater-chart-module’);
var chartModule = new ChartModule();

var docx = new DocxGen()
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
              y: '4.4'
            },
            {
              x: 'day 3',
              y: '1.8'
            }
          ]
        }
      ]
    }
  })
  .render();

var buffer = docx
  .getZip()
  .generate({type:"nodebuffer"});

fs.writeFile("test.docx", buffer);
```
# Options

## Defaults

```javascript
defaultOptions = {
  width: 5486400 / 9525,
  height: 3200400 / 9525,
  grid: true,
  border: true,
  title: false,
  legend: {
    position: 'r', // 'l', 'r', 'b', 't'
  },
  axis: {
    x: {
      orientation: 'minMax', // 'maxMin'
      min: undefined, // number
      max: undefined,
      type: undefined, // 'date'
      date: {
        format: 'unix',
        code: 'mm/yy', // "m/yy;@"
        unit: 'months', // "days"
        step: '1'
      }
    },
    y: {
      orientation: 'minMax',
      mix: undefined,
      max: undefined
    }
  }
}
```

# Building

 You can build the coffee into js by running `gulp` (this will watch the directory for changes)

# Testing

You can test that everything works fine using the command `mocha`. This will also create 3 docx files under the root directory that you can open to check if the docx are correct

# Changelog

### 1.0.0
- Chart creation in loop contributed by colmben

### 0.3.0
- Border option, enabled by default

### 0.2.1
- bug fixes

### 0.2.0
- title option, disabled by default

### 0.1.0
- steps for date type

### 0.0.9
- type 'date' support
- time format in 'unix' or '1900' (amount of days since 1900)
- units for steps on axis
- formatCode for like i.e: 'd/m/yy' or 'm/yyyy'

### 0.0.8
- grid option

### 0.0.7
- lines on axis are still stacking, sadly

### 0.0.6
- x and y axises flipped in options, now correct

### 0.0.5
- min and max axis values options added
- options are nested now for easier readability
