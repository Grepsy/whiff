util            = require('util')
whiff 			    = require('./whiff.js')
WebKitRenderer  = require('./renderers/webkit.js')
DefaultDetector = require('./detector.js').DefaultDetector

app = new whiff.App([new WebKitRenderer()], [new DefaultDetector])
urls = [
  #"http://www.100randomcolors.com/"
  #"http://www.random.org/dice/?num=6"
  "http://www.google.com?q=time"
  "http://www.tweakers.net"
  "http://pricewatch.tweakers.net"
]

app.run urls, null, (result) ->
  console.log result