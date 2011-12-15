util = require('util')

Model = require('./model.js')
#trace = require('./trace')

Whiff 			= require('./whiff.js').Whiff
WebKitRenderer  = require('./renderers/webkit.js').WebKitRenderer
DefaultDetector = require('./detector.js').DefaultDetector

d = (o) ->
	console.log util.inspect(o, 3)

model = new Model.Model
site = new Model.Site
model.sites.push site
#trace.trace site
site.pages.push new Model.Page("http://www.random.org/dice/?num=6")
site.pages.push new Model.Page("http://www.google.com?q=time")
console.log JSON.stringify model
whiff = new Whiff(site, [new WebKitRenderer], [new DefaultDetector])
whiff.run null, (result) ->
	#console.log util.inspect(result, false, null)
	console.log JSON.stringify site
