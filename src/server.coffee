connect = require 'connect'
assets  = require('connect-assets')

connect(
    connect.logger(),
    connect.static(__dirname),
    connect.directory(__dirname),
    assets()
).listen(8000)
console.log "running on #{__dirname}"