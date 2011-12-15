exports ?= this

class DefaultDetector
    id: "simple"

    diff: (oldctx, newctx) =>
        min = Math.min
        minWidth  = min(oldctx.canvas.width, newctx.canvas.width)
        minHeight = min(oldctx.canvas.height, newctx.canvas.height)
        oldimg = oldctx.getImageData(0, 0, minWidth, minHeight)
        newimg = newctx.getImageData(0, 0, minWidth, minHeight)
        totalPixels   = minWidth * minHeight
        pixelsChanged = 0
        for p in [0..totalPixels]
            pixelsChanged++ if oldimg.data[p] != newimg.data[p]

        return pixelsChanged / totalPixels

exports.DefaultDetector = DefaultDetector