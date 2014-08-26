# nehe_02.coffee
# Webgl Version of demo found on nehe.gamedev.net

gl = null
# create matrixi
mvMatrix= mat4.create()
pMatrix = mat4.create()

cubeVertBuff = null
cubeIndexBuff = null
cubeTextCoorfBuff = null

shaderProgram = null

texture = null

xRot = yRot = 0
xSpeed = ySpeed = 0

xTran = -5

filter = 0

initShader = (gl, prog)->
	# Use programs
	gl.useProgram prog

	prog.vertexPositionAttribute = gl.getAttribLocation prog, "aVertexPosition"
	gl.enableVertexAttribArray prog.vertexPositionAttribute

	#prog.vertexColorAttribute = gl.getAttribLocation prog, "aVertexColor"
	#gl.enableVertexAttribArray prog.vertexColorAttribute

	prog.textureCoordAttribute = gl.getAttribLocation prog, "aTextureCoord"
	gl.enableVertexAttribArray prog.textureCoordAttribute

	prog.pMatrixUniform = gl.getUniformLocation prog, "uPMatrix"
	prog.mvMatrixUniform = gl.getUniformLocation prog, "uMVMatrix"

loadTexture = (gl)->
	texture = gl.createTexture()
	texture.image = new Image()
	texture.image.onload = ->
		assetsReady()
	texture.image.src = "img/nehe.gif"

initTexture = (gl) ->
	# bind the loaded texture
	gl.bindTexture gl.TEXTURE_2D, texture
	gl.pixelStorei gl.UNPACK_FLIP_Y_WEBGL, true
	gl.texImage2D gl.TEXTURE_2D, 0, gl.RGBA, gl.RGBA, gl.UNSIGNED_BYTE, texture.image
	gl.texParameteri gl.TEXTURE_2D, gl.TEXTURE_MAG_FILTER, gl.NEAREST
	gl.texParameteri gl.TEXTURE_2D, gl.TEXTURE_MIN_FILTER, gl.NEAREST
	gl.bindTexture gl.TEXTURE_2D, null


window.onload = ->
	gl = window.initWebGL $("#glcanvas")[0]
	shaderProgram = window.loadShaderProg gl, "texture"

	# Init the shader program
	initShader gl, shaderProgram
	loadBuffers()
	loadTexture gl


assetsReady = () ->

	initTexture gl

	gl.clearColor 0.0, 0.0, 0.0, 1.0
	gl.enable gl.DEPTH_TEST

	drawScene()

	setInterval ()-> 
		update()
		drawScene()
	, 1000 / 60


loadBuffers = ->
	loadCube()


loadCube = ->
	cubeVertBuff = gl.createBuffer()
	gl.bindBuffer gl.ARRAY_BUFFER, cubeVertBuff
	gl.bufferData gl.ARRAY_BUFFER, new Float32Array(getCubeVerts()), gl.STATIC_DRAW
	cubeVertBuff.itemSize = 3
	cubeVertBuff.numItems = 24

	#cubeColorBuff = gl.createBuffer()
	#gl.bindBuffer gl.ARRAY_BUFFER, cubeColorBuff
	#gl.bufferData gl.ARRAY_BUFFER, new Float32Array(getCubeColors()), gl.STATIC_DRAW
	#cubeColorBuff.itemSize = 4
	#cubeColorBuff.numItems = 24
	
	# Load texture coords
	cubeTextCoorfBuff = gl.createBuffer()
	gl.bindBuffer gl.ARRAY_BUFFER, cubeTextCoorfBuff
	gl.bufferData gl.ARRAY_BUFFER, new Float32Array(getCubeTexCoord()), gl.STATIC_DRAW
	cubeTextCoorfBuff.itemSize = 2
	cubeTextCoorfBuff.numItems = 24


	cubeIndexBuff = gl.createBuffer()
	gl.bindBuffer gl.ELEMENT_ARRAY_BUFFER, cubeIndexBuff
	cubeVertexIndices = [
		0,  1,  2,      0,  2,  3,    # front
		4,  5,  6,      4,  6,  7,    # back
		8,  9,  10,     8,  10, 11,   # top
		12, 13, 14,     12, 14, 15,   # bottom
		16, 17, 18,     16, 18, 19,   # right
		20, 21, 22,     20, 22, 23    # left
	]
	gl.bufferData gl.ELEMENT_ARRAY_BUFFER, new Uint16Array(cubeVertexIndices), gl.STATIC_DRAW


drawScene = ->
	# init the viewport
	gl.viewport 0, 0, gl.viewportWidth, gl.viewportHeight

	# init the view matrix
	mat4.perspective 45, gl.viewportWidth / gl.viewportHeight, 0.1, 100.0, pMatrix

	# Clear the back buffer
	gl.clear gl.COLOR_BUFFER_BIT | gl.DEPTH_BUFFER_BIT

	mat4.identity mvMatrix
	mat4.translate mvMatrix, [0.0, 0.0, -5.0]
	drawCube()


drawCube = ->
	# rotate
	mat4.rotateX mvMatrix, (xRot)
	mat4.rotateY mvMatrix, (yRot)
	mat4.rotateZ mvMatrix, (zRot)

	gl.bindBuffer gl.ARRAY_BUFFER, cubeVertBuff
	gl.vertexAttribPointer shaderProgram.vertexPositionAttribute, cubeVertBuff.itemSize, gl.FLOAT, false, 0, 0

	#gl.bindBuffer gl.ARRAY_BUFFER, cubeColorBuff
	#gl.vertexAttribPointer shaderProgram.vertexColorAttribute, cubeColorBuff.itemSize, gl.FLOAT, false, 0, 0
	gl.bindBuffer gl.ARRAY_BUFFER, cubeTextCoorfBuff
	gl.vertexAttribPointer shaderProgram.textureCoordAttribute, cubeTextCoorfBuff.itemSize, gl.FLOAT, false, 0, 0


	gl.activeTexture gl.TEXTURE0
	gl.bindTexture gl.TEXTURE_2D, texture
	gl.uniform1i shaderProgram.samplerUniform, 0


	gl.bindBuffer gl.ELEMENT_ARRAY_BUFFER, cubeIndexBuff

	setMatrixUniforms()
	gl.drawElements gl.TRIANGLES, 36, gl.UNSIGNED_SHORT, 0


setMatrixUniforms = ->
	gl.uniformMatrix4fv shaderProgram.pMatrixUniform, false, pMatrix
	gl.uniformMatrix4fv shaderProgram.mvMatrixUniform, false, mvMatrix

update = ->
	#rtri += 0.02
	#rquad -= 0.015
	xRot += 0.02
	yRot += 0.015
	zRot += 0.005



getCubeVerts = ->
	return [
    # Front face
    -1.0, -1.0,  1.0,
     1.0, -1.0,  1.0,
     1.0,  1.0,  1.0,
    -1.0,  1.0,  1.0,
    
    # Back face
    -1.0, -1.0, -1.0,
    -1.0,  1.0, -1.0,
     1.0,  1.0, -1.0,
     1.0, -1.0, -1.0,
    
    # Top face
    -1.0,  1.0, -1.0,
    -1.0,  1.0,  1.0,
     1.0,  1.0,  1.0,
     1.0,  1.0, -1.0,
    
    # Bottom face
    -1.0, -1.0, -1.0,
     1.0, -1.0, -1.0,
     1.0, -1.0,  1.0,
    -1.0, -1.0,  1.0,
    
    # Right face
     1.0, -1.0, -1.0,
     1.0,  1.0, -1.0,
     1.0,  1.0,  1.0,
     1.0, -1.0,  1.0,
    
    # Left face
    -1.0, -1.0, -1.0,
    -1.0, -1.0,  1.0,
    -1.0,  1.0,  1.0,
    -1.0,  1.0, -1.0
  ]
getCubeColors = ->
	colors = [
		[1.0,  1.0,  1.0,  1.0],    # Front face: white
		[1.0,  0.0,  0.0,  1.0],    # Back face: red
		[0.0,  1.0,  0.0,  1.0],    # Top face: green
		[0.0,  0.0,  1.0,  1.0],    # Bottom face: blue
		[1.0,  1.0,  0.0,  1.0],    # Right face: yellow
		[1.0,  0.0,  1.0,  1.0]     # Left face: purple
	]

	generatedColors = []
  
	for j in [0...6]
		c = colors[j];
    
		for i in [0...4]
			generatedColors = generatedColors.concat c

	return generatedColors
getCubeTexCoord = ->
	return [
      # Front face
      0.0, 0.0,
      1.0, 0.0,
      1.0, 1.0,
      0.0, 1.0,

      # Back face
      1.0, 0.0,
      1.0, 1.0,
      0.0, 1.0,
      0.0, 0.0,

      # Top face
      0.0, 1.0,
      0.0, 0.0,
      1.0, 0.0,
      1.0, 1.0,

      # Bottom face
      1.0, 1.0,
      0.0, 1.0,
      0.0, 0.0,
      1.0, 0.0,

      # Right face
      1.0, 0.0,
      1.0, 1.0,
      0.0, 1.0,
      0.0, 0.0,

      # Left face
      0.0, 0.0,
      1.0, 0.0,
      1.0, 1.0,
      0.0, 1.0,
    ]