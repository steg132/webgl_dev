# util.coffee
SHADER_TYPE_FRAGMENT = "x-shader/x-fragment";
SHADER_TYPE_VERTEX = "x-shader/x-vertex";
loadedShaders = {}

window.initWebGL = (canvas) ->
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
	else 
		gl.viewportWidth = canvas.width;
		gl.viewportHeight = canvas.height;

  
	return gl;

window.loadShaderProg = (gl, vertex, fragment)->

	# Check if both shaders are specified
	if not fragment
		fragment = "#{vertex}.fs"
		vertex = "#{vertex}.vs"

	# load shaders here
	loadShader vertex, SHADER_TYPE_VERTEX
	loadShader fragment, SHADER_TYPE_FRAGMENT

	# Get the loaded shaders
	vertShader = getShader gl, vertex
	fragShader = getShader gl, fragment

	# Create Shader Program, and add shaders
	prog = gl.createProgram() 
	gl.attachShader prog, vertShader
	gl.attachShader prog, fragShader
	gl.linkProgram prog

	# Alert if there is an error
	if not gl.getProgramParameter prog, gl.LINK_STATUS
		alert "Could not initialise main shaders"

	# Return created program
	return prog

loadShader = (file, type) ->
	# check if the shader is loaded
	if loadedShaders[file]
		return loadedShaders[file]

	cache = null
	$.ajax 
		async: 		false # need to wait... todo: deferred?
		url: 			"shaders/#{file}" # todo: use global config for shaders folder?
		success: 	(result)-> cache = 
			script: result
			type: type
		error: (req, status, err) ->
			alert "Failed to load shader '#{file}' with status:#{status} Error:#{err}"

	loadedShaders[file] = cache
       
getShader = (gl, id) ->
	shaderObj = loadedShaders[id]
	shaderScript = shaderObj.script
	shaderType = shaderObj.type

	# Create proper Handler
	shader = null
	if shaderType is SHADER_TYPE_FRAGMENT
		shader = gl.createShader gl.FRAGMENT_SHADER
	else if shaderType is SHADER_TYPE_VERTEX
		shader = gl.createShader gl.VERTEX_SHADER
	else 
		return null
	
	# wire up the shader and compile
	gl.shaderSource shader, shaderScript
	gl.compileShader shader

	# if things didn't go so well alert
	if not gl.getShaderParameter shader, gl.COMPILE_STATUS
		alert gl.getShaderInfoLog shader
		return null
	
	return shader


###
loadShader = (vertex, shaderType) ->
	# get shaders
	fragShader = getShader gl, "shader-fs"
	vertShader = getShader gl, "shader-vs"

	# init shader program
	shaderProgram = gl.createProgram()

	# attach shaders to the context
	gl.attachShader shaderProgram, fragShader
	gl.attachShader shaderProgram, vertShader

	#link shaders
	gl.linkProgram shaderProgram

	# check for error
	if not gl.getProgramParameter shaderProgram, gl.LINK_STATUS
		alert "Could not init shaders"

	gl.useProgram shaderProgram

	shaderProgram.vertexPositionAttribute = gl.getAttribLocation shaderProgram, "aVertexPosition"
	gl.enableVertexAttribArray shaderProgram.vertexPositionAttribute

	shaderProgram.pMatrixUniform = gl.getUniformLocation shaderProgram, "uPMatrix"
	shaderProgram.mvMatrixUniform = gl.getUniformLocation shaderProgram, "uMVMatrix"

	return shaderProgram



getShader = (gl, id) ->
      shaderScript = document.getElementById id 
      if not shaderScript
          return null
      

      str = ""
      k = shaderScript.firstChild
      while k
          if k.nodeType is 3
              str += k.textContent
          k = k.nextSibling
      

      shader = null
      if shaderScript.type is "x-shader/x-fragment"
          shader = gl.createShader gl.FRAGMENT_SHADER
      else if shaderScript.type is "x-shader/x-vertex"
          shader = gl.createShader gl.VERTEX_SHADER
      else 
          return null

      gl.shaderSource shader, str
      gl.compileShader shader

      if not gl.getShaderParameter shader, gl.COMPILE_STATUS
          alert gl.getShaderInfoLog shader
          return null

      return shader
###



  