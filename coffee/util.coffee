# util.coffee


initWebGL = (canvas) ->
	gl = null
  
	try 
	    # Try to grab the standard context. If it fails, fallback to experimental.
	    gl = canvas.getContext("webgl") || canvas.getContext "experimental-webgl"
  
	catch e
  		print e
  
	# If we don't have a GL context, give up now
	if not gl
		alert "Unable to initialize WebGL. Your browser may not support it."
		gl = null
  
	return gl;
