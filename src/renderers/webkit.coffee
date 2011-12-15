path = require 'path'

class WebKitRenderer
    id: "webkit"
    path: path.join __dirname, '../../lib/phantomjs'
    timeout: 10 * 1000

    render: (url, path, callback) ->
        exec = require('child_process').exec
        opts = { cwd: __dirname, timeout: @timeout }
        exec "#{@path}/phantomjs.exe raster.coffee #{url} #{path}", opts, (error) ->
            result =
                status: if error? then "error" else "ok"
                message: if error? then error.message ? "Timed out."
                image: path

            callback result

exports ?= this
exports = module.exports = WebKitRenderer