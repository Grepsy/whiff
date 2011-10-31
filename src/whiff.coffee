async = require 'async'
util  = require 'util'
fs    = require 'fs'
path  = require 'path'

class App
    constructor: (@renderers, @detectors) ->
        @data ?= {}
        if path.existsSync "data.json"
            @data = JSON.parse(fs.readFileSync("data.json", "utf8"))

    # Makes new captures and diffs from the supplied URLs. You can supply an ID to 
    # be used, for example a commit hash.
    run: (urls, id = Date.now(), callback) ->
        captureKey = Date.now()
        queue = async.queue((url, callback) =>
            page = @data[url] ?= {}
            page.captures ?= {}
            @capture(url, id, (result) ->
                page.captures[captureKey] = result
                callback()
            )
        , 2)
        queue.drain = =>
            fs.writeFile("data.json", JSON.stringify(@data))
            callback(@data)
        queue.push url for url in urls

    capture: (url, id, callback) ->
        capture =
            renders: {}
            identifier: id
        
        render = (renderer, callback) ->
            path = "./#{renderer.id}-#{Date.now()}.png"
            console.log("[render] #{renderer.id} #{url}")
            renderer.render url, path, (result) ->
                capture.renders[renderer.id] = result
                callback()
        
        async.forEach @renderers, render, -> callback(capture)

    diff: (older, newer, callback) ->
        diff = 
            older: older
            newer: newer
            results: {}

        for detector in this.detectors
            console.log("[detect] #{detector.id}")
            results[detector.id] = detector.detect(older, newer)

        return diff
        
class WebKitRenderer
    id: "webkit"

    render: (url, path, callback) ->
        exec = require('child_process').exec
        exec "phantomjs rasterize.coffee #{url} #{path}", (error) ->
            result = 
                status: if error? then "error" else "ok"
                message: if error? then error.message
                image: path
            callback result

class FakeDetector
    id: "fake"

    detect: (older, newer) ->
        result = 
            status: "warning"
            message: "Page changed 13% which is more than the treshold (5%)."
        result


urls = [
    "http://www.google.com?q=time"
    "http://www.google.com?q=time"
    "http://www.google.com?q=time"
]

app = new App([new WebKitRenderer], [new FakeDetector])
app.run urls, "testid", (result) ->   
    console.log util.inspect(result, true, 10)
