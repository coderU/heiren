app = require './config/setup'

server = app.listen process.env.PORT || 3000, () ->
  console.log 'server listening on port ' + server.address().port
