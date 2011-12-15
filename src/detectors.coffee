Canvas  = require('canvas')
fs      = require('fs')
min     = Math.min
log     = (o) -> console.log require('util').inspect o
SimpleDiff = require('./simple')

loadCanvasWithImage = (path) ->
    img = new Canvas.Image
    img.src = fs.readFileSync(path)
    canvas = new Canvas(img.width, img.height)
    canvas.getContext('2d').drawImage(img, 0, 0, img.width, img.height)
    return canvas
    
oldctx = loadCanvasWithImage('a.png').getContext('2d')
newctx = loadCanvasWithImage('b.png').getContext('2d')

simple = new SimpleDiff
simple.diff(oldctx, newctx)