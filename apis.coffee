express    = require 'express'
morgan     = require 'morgan'
path       = require 'path'
expressJwt = require 'express-jwt'
###############################################################################################
# Service models
#champion = require './apis/champion'
# login    = require './login/login'
# discover = require './discover/discover'
config   = require './config/config.json'
# friends  = require './friends/friends'
# gifts  = require './gifts/gifts'
# inbox  = require './inbox/inbox'
users  = require './apis/users'
###############################################################################################
apis = ->
  router = express.Router()

  jwtSecret = config.jwtSecret

  # Add logger
  router.use morgan 'dev'

  # Add authentication
  router.use (expressJwt secret: jwtSecret
      .unless path: ['/', '/users/register', '/api/login'])

  # Add routers
  #router.use '/champion', champion
  # router.use '/api/login', login
  # router.use '/api/friends', friends
  # router.use '/api/discover', discover
  # router.use '/api/gifts', gifts
  # router.use '/api/inbox', inbox
  router.use '/users', users
  # Send front end page to user
  # router.get '/', (req, res) ->
  #   res.sendFile path.resolve 'app/mobile/index.html'

  return router


module.exports = apis()
