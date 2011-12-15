exports ?= this

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
       
exports.WebKitRenderer = WebKitRenderer