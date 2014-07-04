# server.js

express = require 'express'
app = express()

# return hello text for testing
app.get '/hello.txt', (req, res) ->
  res.send 'Hello World'

app.use express.static(__dirname) # Current directory is root

server = app.listen 3000, () ->
    console.log 'Listening on port %d', server.address().port



