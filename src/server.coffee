connect = require 'connect'
assets  = require 'connect-assets'
path    = require 'path'

connect(
    assets(),
    #connect.logger(),
    connect.static __dirname,
    connect.directory __dirname
).listen(8000)

console.log "running on #{__dirname}, port 8000."