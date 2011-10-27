class App
    constructor: (@renderers, @detectors, @data) ->
    	if not data
    		data = []

    run: (urls) ->
        results = []
        for url in urls
        	results.push(this.proces(url));
        results

    proces: (url) ->
        urlData = data[url]
        pageResult =
        	result: "fail"
        
        for renderer in this.renderers
	        console.log("[render] #{renderer.id} #{url}")
	        renderResult = renderer.render(url)
	        urlData.captures.push(renderResult)

	        previousImage = urlData.captures[urlData.captures.length].image
	        if (!previousImage)
	        	renderResult.result = "warning"
	        	renderResult.message = "No previous rendering, can't compare."
	        	continue

	        detectResults = []
	        for detector in this.detectors
	        	console.log("[detect] #{detector.id}")
	        	result = 
	        		url: url
	        		result: detector.detect(previousImage, renderResult.image)
	        	detectResults.push result
	        
	        urlData.reports.push(detectResults)




class WebKitRenderer
	id: "webkit"

	render: (url) ->
		console.log("Do some rendering in phantomjs, output img")
		result = 
			status: "ok"
			image: "imagename.png"
		result

class FakeDetector
	id: "fake"

	detect: (previous, new) ->
		result = 
			status: "warning"
			message: "Page changed 13% which is more than the treshold (5%)."
		result


urls = [
    "http://www.google.com?q=time"
]

app = new App
app.run urls
