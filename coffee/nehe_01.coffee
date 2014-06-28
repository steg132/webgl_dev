# nehe_01.coffee
# Webgl Version of demo found on nehe.gamedev.net

gl = null

window.onload = ->
	gl = initWebGL $ "#glcanvas"
