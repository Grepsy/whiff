exports ?= this

util     = require 'util'
fs       = require 'fs'
path     = require 'path'
async    = require 'async'
backbone = require 'backbone'

class Snap extends backbone.Model
    defaults: ->
        url: ''
        date: Date.now()
        renders: new Array()
        commit: Date.now()

    capture: (renderers, callback) =>
        render = (renderer, callback) =>
            path = "#{__dirname}/data/#{Date.now()}-#{renderer.id}.png"
            console.log("[render] [#{renderer.id}] #{@get('url')}")
            renderer.render @get('url'), path, (results) =>
                @get('renders').push results
                callback()

        queue = async.queue(render, 2)
        queue.drain = callback
        queue.push renderer for renderer in renderers

class Snaps extends backbone.Collection
    model: Snap

class App extends backbone.Model
    constructor: (@renderers, @detectors) ->

    snaps: new Snaps

    # Makes new captures and diffs from the supplied URLs. You can supply an
    # ID to be used, for example a commit hash or version number.
    run: (urls, commit = Date.now(), callback) =>
        snapshot = (url, cb) =>
            snap = @snaps.create({ commit: commit, url: url })
            snap.capture @renderers, cb

        queue = async.queue(snapshot, 2)
        queue.drain = => callback @snaps.toJSON()
        queue.push url for url in urls

    diff: (task, callback) =>
        console.log("[detect] #{detector.id}")
        diff =
            older: task.older
            newer: task.newer
            results: {}

        results[detector.id] = detector.detect(older, newer)
        diff

class Persistence
    save: (model) ->
        fs.writeFile("data.json", JSON.stringify(model))

    load: ->
        model = {}
        if path.existsSync "data.json"
            model = JSON.parse(fs.readFileSync("data.json", "utf8"))
        model

backbone.sync = (method, model, options) ->
    options.success()
exports.App = App