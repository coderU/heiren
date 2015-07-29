mongoose = require 'mongoose'
crypto = require 'crypto'
Schema = mongoose.Schema

UserModel = () ->
  userSchema = new Schema
    email: { type: String, unique: true},
    full_name   : String,
    avatar   : String,
    password : String,
    salt     : String,

  # Hash information
  # userSchema.pre 'save', (next) ->
  #   user = this;
  #
  #   user.avatar = 'default-avatar.jpg'
  #   user.salt = crypto.randomBytes(128).toString 'base64'
  #
  #   crypto.pbkdf2 user.password, user.salt, 10000, 512, (err, derivedKey) ->
  #     hashedKey = derivedKey.toString 'utf8'
  #     user.password = hashedKey
  #     next()

  userSchema.methods.register = (callback) ->
    user = this;
    user.avatar = 'default-avatar.jpg'
    user.salt = crypto.randomBytes(128).toString 'base64'

    crypto.pbkdf2 user.password, user.salt, 10000, 512, (err, derivedKey) ->
      hashedKey = derivedKey.toString 'utf8'
      user.password = hashedKey
      
      user.save callback

  User = mongoose.model 'User', userSchema

  return User

module.exports = UserModel()
