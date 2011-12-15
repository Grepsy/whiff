root = exports ? this

root.loadCanvasWithImage = (path, callback) ->
    img = new Image
    img.addEventListener 'load', ->
        console.log "Image loaded", img, img.width
        canvas = document.createElement('canvas')
        canvas.width = img.width
        canvas.height = img.height
        canvas.getContext('2d').drawImage(img, 0, 0, img.width, img.height)
        callback(canvas)
    img.src = path

oldctx = loadCanvasWithImage('a.png').getContext('2d')
newctx = loadCanvasWithImage('b.png').getContext('2d')

simple = new SimpleDiff
simple.diff(oldctx, newctx)