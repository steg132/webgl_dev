# util.coffee


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

window.loadShader = (gl) ->
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
  