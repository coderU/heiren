express = require 'express'
_und    = require 'underscore'
jwt     = require 'jsonwebtoken'
User    = require '../config/Models/Users'
config  = require '../config/config.json'

register = ->
  router = express.Router()

  jwtSecret = config.jwtSecret
  # Creat a new user
  router.post '/register', (req, res) ->
    userInfo = _und.pick req.body,
      'email', 'full_name', 'password'

    #TODO need verify if it is an email address

    if not userInfo.full_name?
      res.status(500).send 'Please fill both first name and last name\n'
      return

    if not userInfo.password?
      res.status(500).send 'Please set up your password\n'
      return

    User
      .findOne 'email': userInfo.email
      .select 'email'
      .exec (err, dupName) ->
        if dupName?
          res.status(500).send 'This email is already registered\n'
        else
          newUser = new User userInfo
          cb = (err, user) ->
            if err?
              res.status(500).send err.message
            else
              token = _und.pick user,
                '_id'
              # TODO expiration
              res.send jwt.sign token, jwtSecret

          newUser.register(cb);
    # res.status(500).send 'Unknown error!'
    # Login
  router.post '/login', (req, res) ->
    loginInfo = _und.pick req.body,
      '_id', 'password'

    if not loginInfo._id? or not loginInfo._id.match(/^[a-zA-Z0-9]+$/)?
      res.status(400).send '登录名只包含数字和英文，请重新输入\n'
      return

    if not loginInfo.password?
      res.status(400).send '请输入密码\n'
      return

    User
      .findOne '_id': loginInfo._id
      .exec (err, user) ->
        if not user?
          res.status(400).send '登录名不存在，请注册\n'
        else
          # TODO Refactor with promise bluebird
          crypto.pbkdf2 loginInfo.password, user.salt, 10000, 512, (err, derivedKey) ->
            hashedKey = derivedKey.toString 'utf8'
            if hashedKey == user.password
              token = _und.pick user,
                '_id'
              # TODO expiration
              res.send jwt.sign token, jwtSecret
            else
              # TODO try restriction
              res.status(400).send '密码错误\n'


  return router


module.exports = register()
