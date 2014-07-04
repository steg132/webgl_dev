# nehe_02.coffee
# Webgl Version of demo found on nehe.gamedev.net

gl = null
# create matrixi
mvMatrix= mat4.create()
pMatrix = mat4.create()

pyramidVertBuff = null
pyramidColorBuff = null
pyramidIndexBuff = null

cubeVertBuff = null
cubeColorBuff = null
cubeIndexBuff = null

shaderProgram = null

rtri = 0
rquad = 0

initShader = (gl, prog)->
	# Use programs
	gl.useProgram prog

	prog.vertexPositionAttribute = gl.getAttribLocation prog, "aVertexPosition"
	gl.enableVertexAttribArray prog.vertexPositionAttribute

	prog.vertexColorAttribute = gl.getAttribLocation prog, "aVertexColor"
	gl.enableVertexAttribArray prog.vertexColorAttribute

	prog.pMatrixUniform = gl.getUniformLocation prog, "uPMatrix"
	prog.mvMatrixUniform = gl.getUniformLocation prog, "uMVMatrix"


window.onload = ->
	gl = window.initWebGL $("#glcanvas")[0]
	shaderProgram = window.loadShaderProg gl, "color.vs", "color.fs"

	# Init the shader program
	initShader gl, shaderProgram

	loadBuffers()

	gl.clearColor 0.0, 0.0, 0.0, 1.0
	gl.enable gl.DEPTH_TEST

	drawScene()

	setInterval ()-> 
		update()
		drawScene()
	, 1000 / 60


loadBuffers = ->
	loadPyramid()
	loadCube()

loadPyramid = ->
	# Load Triangle Buffer
	pyramidVertBuff = gl.createBuffer()
	gl.bindBuffer gl.ARRAY_BUFFER, pyramidVertBuff
	gl.bufferData gl.ARRAY_BUFFER, new Float32Array(getPyramidVerts()), gl.STATIC_DRAW

	# set required properties
	pyramidVertBuff.itemSize = 3
	pyramidVertBuff.numItems = 5

	# Load colors
	pyramidColorBuff = gl.createBuffer()
	gl.bindBuffer gl.ARRAY_BUFFER, pyramidColorBuff
	gl.bufferData gl.ARRAY_BUFFER, new Float32Array(getPyramidColors()), gl.STATIC_DRAW
	pyramidColorBuff.itemSize = 4
	pyramidColorBuff.numItems = 5

	# Load indicies
	pyramidIndexBuff = gl.createBuffer()
	gl.bindBuffer gl.ELEMENT_ARRAY_BUFFER, pyramidIndexBuff
	indicies = [
		0, 1, 2,
		0, 2, 3,
		0, 3, 4,
		0, 4, 1
	]
	gl.bufferData gl.ELEMENT_ARRAY_BUFFER, new Uint16Array(indicies), gl.STATIC_DRAW


loadCube = ->
	cubeVertBuff = gl.createBuffer()
	gl.bindBuffer gl.ARRAY_BUFFER, cubeVertBuff
	gl.bufferData gl.ARRAY_BUFFER, new Float32Array(getCubeVerts()), gl.STATIC_DRAW
	cubeVertBuff.itemSize = 3
	cubeVertBuff.numItems = 24

	cubeColorBuff = gl.createBuffer()
	gl.bindBuffer gl.ARRAY_BUFFER, cubeColorBuff
	gl.bufferData gl.ARRAY_BUFFER, new Float32Array(getCubeColors()), gl.STATIC_DRAW
	cubeColorBuff.itemSize = 4
	cubeColorBuff.numItems = 24


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

	# clear matrix
	mat4.identity mvMatrix
	drawTriangle()

	mat4.identity mvMatrix
	drawSquare()


drawTriangle = ->
	# Draw the triangle 
	# Transalate to the triangle position
	mat4.translate mvMatrix, [-1.5, 0.0, -7.0]
	mat4.rotateY mvMatrix, rtri

	gl.bindBuffer gl.ARRAY_BUFFER, pyramidVertBuff
	gl.vertexAttribPointer shaderProgram.vertexPositionAttribute, pyramidVertBuff.itemSize, gl.FLOAT, false, 0, 0

	gl.bindBuffer gl.ARRAY_BUFFER, pyramidColorBuff
	gl.vertexAttribPointer shaderProgram.vertexColorAttribute, pyramidColorBuff.itemSize, gl.FLOAT, false, 0, 0

	gl.bindBuffer gl.ELEMENT_ARRAY_BUFFER, pyramidIndexBuff

	setMatrixUniforms()

	# Lets Draw Tris!
	gl.drawElements gl.TRIANGLES, 12, gl.UNSIGNED_SHORT, 0
	#0, triangleVertBuff.numItems

drawSquare = ->
	mat4.translate mvMatrix, [1.5, 0.0, -7.0]
	mat4.rotate mvMatrix, rquad, [1.0, 1.0, 0.0]

	gl.bindBuffer gl.ARRAY_BUFFER, cubeVertBuff
	gl.vertexAttribPointer shaderProgram.vertexPositionAttribute, cubeVertBuff.itemSize, gl.FLOAT, false, 0, 0

	gl.bindBuffer gl.ARRAY_BUFFER, cubeColorBuff
	gl.vertexAttribPointer shaderProgram.vertexColorAttribute, cubeColorBuff.itemSize, gl.FLOAT, false, 0, 0

	gl.bindBuffer gl.ELEMENT_ARRAY_BUFFER, cubeIndexBuff

	setMatrixUniforms()
	gl.drawElements gl.TRIANGLES, 36, gl.UNSIGNED_SHORT, 0


setMatrixUniforms = ->
	gl.uniformMatrix4fv shaderProgram.pMatrixUniform, false, pMatrix
	gl.uniformMatrix4fv shaderProgram.mvMatrixUniform, false, mvMatrix

update = ->
	rtri += 0.02
	rquad -= 0.015


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

getPyramidVerts = ->
	return [
		 0.0,  1.0,  0.0,
		-1.0, -1.0,  1.0, # green
		 1.0, -1.0,  1.0, # green
		 1.0, -1.0, -1.0, # blue
		-1.0, -1.0, -1.0, # blue
	]

getPyramidColors = ->
	return [
		 1.0,  0.0,  0.0,  1.0,
		 0.0,  1.0,  0.0,  1.0,
		 0.0,  1.0,  0.0,  1.0,
		 0.0,  0.0,  1.0,  1.0,
		 0.0,  0.0,  1.0,  1.0
	]
