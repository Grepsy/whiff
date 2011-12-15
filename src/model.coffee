async = require 'async'

class Model
    sites: []

class Site
    pages: []

    capture: (renderers, id, callback) =>
        queue = async.queue(((page, cb) -> page.capture(renderers, id, cb)), 3)
        queue.drain = callback
        queue.push page for page in @pages

class Page
    captures: []

    constructor: (@url) ->

    capture: (renderers, id, callback) =>
        @captures.push capture = new Capture
        capture.capture @url, renderers, id, callback
                
class Capture
    date: Date.now()
    renders: []
    
    capture: (url, renderers, @id = Date.now(), callback) =>
        render = (renderer, cb) =>
            console.log("[render] [#{renderer.id}] #{url}")
            renderer.render url, "#{renderer.id}-#{@id}.png", (results) =>
                @renders.push results
                cb()
        
        queue = async.queue(render, 2)
        queue.drain = callback
        queue.push renderer for renderer in renderers

exports.Model = Model
exports.Site = Site
exports.Page = Page
exports.Capture = Capture