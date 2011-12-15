util  = require 'util'
stack = []

trace = (o) ->
	for key, value of o
		if typeof value is "function"
			o[key] = intercept(key, value)

intercept = (name, fn) -> 
	return () ->
		stack.push { name: name, args:  Array.prototype.slice.call(arguments) }
		ret = fn.apply(this, arguments)
		stack.pop
		ret

stacktrace = (err) ->
	console.log "#{err}"
	for frame in stack
		console.log "  at #{frame.name} (" 
		for arg in frame.args
			console.log "    " + util.inspect(arg, 0) + ","
		console.log "  )"

process.on 'uncaughtException', stacktrace
	
exports.trace = trace