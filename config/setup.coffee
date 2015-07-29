express    = require 'express'
bodyParser = require 'body-parser'
mongoose   = require 'mongoose'
apis = require '../apis'
server = () ->
  app = express()

  # Add bodyParser
  app.use bodyParser.urlencoded
    'extended':'true'

  app.use bodyParser.json
    limit: '550kb'

  app.use bodyParser.json
    type: 'application/vnd.api+json'

  app.use express.static 'public'
  app.use express.static 'app'

  db = 'mongodb://127.0.0.1:27017/heiren'
  mongoose.connect db

  app.use '/', apis

module.exports = server()
