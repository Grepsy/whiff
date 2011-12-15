page = new WebPage()

if phantom.args.length isnt 2
  console.log 'Usage: rasterize.js URL filename'
  phantom.exit(1)
else
  address = phantom.args[0]
  output = phantom.args[1]
  page.viewportSize = { width: 1024, height: 600 }
  page.open address, (status) ->
    if status isnt 'success'
      console.log "Error loading page."
      phantom.exit(1)
    else
      page.render output
      phantom.exit()
