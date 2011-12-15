exports ?= this

util  = require 'util'
fs    = require 'fs'
path  = require 'path'

d = (o) ->
    console.log util.inspect(o)

class Whiff
    constructor: (@model, @renderers, @detectors) ->
        # @data ?= {}
        # if path.existsSync "data.json"
        #     @data = JSON.parse(fs.readFileSync("data.json", "utf8"))

    # Makes new captures and diffs from the supplied URLs. You can supply an 
    # ID to be used, for example a commit hash or version number.
    run: (id = Date.now(), callback) =>
        #fs.writeFile("data.json", JSON.stringify(@data))
        @model.sites.forEach -> (site) site.capture(@renderers, null, callback)

    diff: (task, callback) =>
        console.log("[detect] #{detector.id}")
        diff = 
            older: task.older
            newer: task.newer
            results: {}

        results[detector.id] = detector.detect(older, newer)
        return diff

exports.Whiff = Whiff