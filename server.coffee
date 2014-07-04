# server.js

express = require 'express'
app = express()

# return hello text for testing
app.get '/hello.txt', (req, res) ->
  res.send 'Hello World'

app.use express.static(__dirname) # Current directory is root
#app.use "/shaders", express.static(__dirname, {Content-Type: x-shader/x-vertex}) 

express.static.mime.define {'text/plain': ['md']}
express.static.mime.define {'x-shader/x-vertex': ['vs']}
express.static.mime.define {'x-shader/x-fragment': ['fs']}
 

server = app.listen 3000, () ->
    console.log 'Listening on port %d', server.address().port



