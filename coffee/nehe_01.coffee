# nehe_01.coffee
# Webgl Version of demo found on nehe.gamedev.net

gl = null
# create matrixi
mvMatrix= mat4.create()
pMatrix = mat4.create()

triangleVertBuff = null
squareVertBuff = null

shaderProgram = null



window.onload = ->
	gl = window.initWebGL $("#glcanvas")[0]
	shaderProgram = window.loadShader gl
	loadBuffers()

	gl.clearColor 0.0, 0.0, 0.0, 1.0
	gl.enable gl.DEPTH_TEST

	drawScene()


loadBuffers = ->
	# Load Triangle Buffer
	triangleVertBuff = gl.createBuffer()
	gl.bindBuffer gl.ARRAY_BUFFER, triangleVertBuff
	verts = [
		 0.0,  1.0,  0.0,
		-1.0, -1.0,  0.0,
		 1.0, -1.0,  0.0
	]

	gl.bufferData gl.ARRAY_BUFFER, new Float32Array(verts), gl.STATIC_DRAW

	# set required properties
	triangleVertBuff.itemSize = 3
	triangleVertBuff.numItems = 3

	# Load the square buffer

	squareVertBuff = gl.createBuffer()
	gl.bindBuffer gl.ARRAY_BUFFER, squareVertBuff
	verts = [
		 1.0,  1.0,  0.0,
		-1.0,  1.0,  0.0,
		 1.0, -1.0,  0.0,
		-1.0, -1.0,  0.0
	]

	#bind the data
	gl.bufferData gl.ARRAY_BUFFER, new Float32Array(verts), gl.STATIC_DRAW

	squareVertBuff.itemSize = 3
	squareVertBuff.numItems = 4

drawScene = ->
	# init the viewport
	gl.viewport 0, 0, gl.viewportWidth, gl.viewportHeight

	# init the view matrix
	mat4.perspective 45, gl.viewportWidth / gl.viewportHeight, 0.1, 100.0, pMatrix

	# Clear the back buffer
	gl.clear gl.COLOR_BUFFER_BIT | gl.DEPTH_BUFFER_BIT

	# clear matrix
	mat4.identity mvMatrix

	# Draw the triangle 
	# Transalate to the triangle position
	mat4.translate mvMatrix, [-1.5, 0.0, -7.0]

	gl.bindBuffer gl.ARRAY_BUFFER, triangleVertBuff
	gl.vertexAttribPointer shaderProgram.vertexPositionAttribute, triangleVertBuff.itemSize, gl.FLOAT, false, 0, 0

	setMatrixUniforms()

	# Lets Draw Tris!
	gl.drawArrays gl.TRIANGLES, 0, triangleVertBuff.numItems

	mat4.translate mvMatrix, [3.0, 0, 0]
	gl.bindBuffer gl.ARRAY_BUFFER, squareVertBuff
	gl.vertexAttribPointer shaderProgram.vertexPositionAttribute, squareVertBuff.itemSize, gl.FLOAT, false, 0, 0

	setMatrixUniforms()
	gl.drawArrays gl.TRIANGLE_STRIP, 0, squareVertBuff.numItems




setMatrixUniforms = ->
	gl.uniformMatrix4fv shaderProgram.pMatrixUniform, false, pMatrix
	gl.uniformMatrix4fv shaderProgram.mvMatrixUniform, false, mvMatrix










